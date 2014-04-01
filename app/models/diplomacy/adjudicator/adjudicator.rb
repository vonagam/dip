require_relative 'orders'
require_relative 'backup_rule'

module Diplomacy
  class Validator
    def initialize(state, map, order_list, class_list)
      @logger = Diplomacy.logger
      @state = state
      @map = map
      @orders = OrderCollection.new(order_list)
      @invalid_orders = []
      @class_list = class_list
    end
    
    def validate_orders(substitute_holds=true)
      @orders.each do |order|
        order.invalidate unless valid_order?(order) and @class_list.member? order.class
        @logger.debug "Decided: #{order.status_readable}"
      end
      sanitized_orders = @orders.orders.collect do |order|
        substitute = substitute_holds ? Hold.new(order.unit, order.unit_area) : nil
        order.invalid? ? substitute : order
      end
      invalid_orders = @orders.orders.collect {|order| order.invalid? ? order : nil }
      
      return OrderCollection.new(sanitized_orders), invalid_orders
    end
    
    def valid_order?(order)
      @logger.debug "Validating #{order}"
      case order
      when Move
        return true if valid_move?(order)
        
        return false if order.unit_area == order.dst # it's easier to be explicit
        
        # if army, invalid move might be part of a convoy
        # we only care if unit_area and dst are coastal, path() will take care of the rest
        return false unless order.unit.is_army? && @map.areas[order.unit_area].is_coastal? && @map.areas[order.dst].is_coastal?
      when Support
        m = Move.new(order.unit, order.unit_area, order.dst)
        m.unit_area_coast = order.unit_area_coast
        return false unless valid_move?(m) # check whether unit can move to dst, disregarding dst coast
        
        # check whether supported move is valid, as well
        m = @orders.supported_move(order)
        return false unless valid_order?(m)
      when Convoy
        # if in coastal area, fail
        return false unless @map.areas[order.unit_area].borders[Area::LAND_BORDER].empty?
        
        m = Move.new(@state[order.src].unit, order.src, order.dst)
        m.unit_area_coast = order.src_coast
        m.dst_coast = order.dst_coast
        return false unless valid_order?(m)
      when Retreat
        return (valid_move?(order) and (not @state.dislodges[order.unit_area].nil?))
      when Build
        area = @map.areas[order.unit_area]
        if order.build
          return (
            @state[order.unit_area].unit.nil? and (
              (order.unit.is_army? and area.is_land?) or
              (order.unit.is_fleet? and area.is_coastal?)
            )
          )
        else # disband
          return (not @state[order.unit_area].unit.nil?)
        end
      end
      true
    end
    
    def valid_move?(move)
      if move.unit.is_army?
        return @map.neighbours?(move.unit_area, move.dst, Area::LAND_BORDER)
      elsif move.unit.is_fleet?
        return @map.neighbours?(move.unit_area_with_coast, move.dst_with_coast, Area::SEA_BORDER)
      end
    end
  end
  
  class Adjudicator
    attr_accessor :orders
    attr_accessor :map
    
    def initialize(map = nil, backup_rule=nil, adjust=false)
      @logger = Diplomacy.logger
      if map
        @map = map
      else
        mr = MapReader.new
        @map = mr.maps['Standard']
      end
      @backup_rule = backup_rule || BackupRule.new(:simple_circular, :convoy_paradox)
    end

    def resolve!(state, unchecked_orders, adjust=false)
      validator = Validator.new(state, @map, unchecked_orders, [Move, Support, SupportHold, Convoy, Hold])
      @orders, invalid_orders = validator.validate_orders
      
      @state = state
      @loop_detector = []
      
      @orders.each do |order|
        resolve_order!(order)
      end
      
      reconcile!(@orders.orders, invalid_orders)
      
      state.apply_orders! @orders.orders

      state.adjust!(@map) if adjust
      
      return state,@orders.orders
    end

    def resolve_order!(order)
      if order.resolved?
        @logger.debug "#{order} already resolved: #{order.status_readable}"
        return
      end
      
      unless @loop_detector.member?(order) or order.guessing?
        @loop_detector << order
      else
        @logger.debug("Loop detected: #{@loop_detector} (but @loop is #{@loop})")
        
        loop = Array.new(@loop_detector)
          @loop_detector = []
          
          unless @loop # if already in a loop, don't try to second guess (heh)
            unless guess_resolve!(loop)
              @backup_rule.resolve!(loop)
            end
          end
          
          return
        end
        
        dependencies = get_dependencies(order)
        
        dependencies.each do |dependency|
          resolve_order!(dependency)
        end
      
      @loop_detector.delete(order)
      
      # sets order status
      adjudicate!(order)
    end
    
    def get_dependencies(order)
      dependencies = []
      case order
      when Move
        # get all convoys for this move
        dependencies.concat(@orders.convoys_for_move(order))
        
        # get all moves to the same destination
        #dependencies.concat(@orders.moves_by_dst(order.dst, skip_me=true, me=order))
        
        # get all supports to my area (for HtHs)
        dependencies.concat(@orders.supports_by_dst(order.unit_area))
        
        # get all supports to the destination
        dependencies.concat(@orders.supports_by_dst(order.dst))
        
        # get all support holds to the destination
        dependencies.concat(@orders.supportholds_to(order.dst))
        
        # get the move leaving from the destination - can only be one or zero
        dep_move = @orders.moves_by_origin(order.dst)
        
        unless dep_move.nil?
          # check if either move convoyed - in that case there is no head to head
          not_convoyed = @orders.convoys_for_move(dep_move).empty? || @orders.convoys_for_move(order).empty?
		  @logger.debug "#{dep_move}, convoyed: #{!not_convoyed}"
          
          # add the move from the destination unless it's a head to head
          dependencies << dep_move unless dep_move.dst == order.unit_area && not_convoyed
        end
      when Support, SupportHold
        # get all moves towards this area
        moves_to_area = @orders.moves_by_dst(order.unit_area)
        
        # add moves in case one of them dislodges this support
        dependencies.concat(moves_to_area)
        
        # get related convoy orders - these are the most important dependencies
        moves_to_area.each do |move|
          # get all convoys for this move
          dependencies.concat(@orders.convoys_for_move(move))
        end
      when Hold
        # intentionally empty: Holds have no dependencies
      when Convoy
        dependencies.concat(@orders.moves_by_dst(order.unit_area)) 
      end
      
      @logger.debug "Dependencies for #{order} are #{dependencies}"
      
      dependencies
    end
    
    def adjudicate!(order)
      @logger.debug "Adjudicating #{order}"
      if order.resolved?
        @logger.debug "#{order} already resolved: #{order.status_readable}"
        return
      end
      
      case order
      when Move        
        # check for head to head battle
        head_to_head_move = nil
        
        dst_move = @orders.moves_by_origin(order.dst)
        head_to_head_move = dst_move if (not dst_move.nil?) and dst_move.dst == order.unit_area
        
        # check if move convoyed
        convoyed = !((@orders.convoys_for_move(order).reject {|convoy| convoy.resolved? && convoy.failed? }).empty?)
        
        attack_strength = calculate_attack_strength(order)
        
        @logger.debug "Has attack strength #{attack_strength}"
        
        competing_strengths = []
        
        unless head_to_head_move.nil? || convoyed
          # there is a head to head battle
          competing_strengths << calculate_defend_strength(head_to_head_move)
          @logger.debug "Defend strength for #{head_to_head_move}: #{competing_strengths[0]}"
        else
          # there is no head to head battle
          competing_strengths << calculate_hold_strength(order.dst)
          @logger.debug "Hold strength for #{order.dst}: #{competing_strengths[0]}"
        end
        
        # competing moves - if opponent dislodged in a head to head, they don't prevent
        @orders.moves_by_dst(order.dst, skip_me=true, me=order).each do |competing_move|
          dislodger = dislodged(competing_move)
          unless (not dislodger.nil?) && competing_move.dst == dislodger.unit_area
            competing_strengths << calculate_prevent_strength(competing_move)
            @logger.debug "Prevent strength for #{competing_move}: #{competing_strengths[-1]}"
          end
        end
        
        competing_strengths.sort!
        
        @logger.debug "Competing strengths: #{competing_strengths}"
        
        competing_strengths.empty? || attack_strength > competing_strengths[-1] ? 
          order.succeed : order.fail
      when Support, SupportHold
        if dislodged(order)
          order.fail
          @logger.debug "Decision (#{order}): #{order.resolution_readable}"
          return
        end
          
        # get all moves against this area
        moves_to_area = @orders.moves_by_dst(order.unit_area)
        
        moves_to_area.each do |move|
          if order.nationality != move.nationality &&
              move.unit_area != order.dst && check_path(move)
            order.fail
            @logger.debug "Decision (#{order}): #{order.resolution_readable}"
            return 
          end
        end
          
        # no moves have cut this support, so it succeeds (with exception below)
        order.succeed
        
        if SupportHold === order 
          # support holds fail if the supported unit moves
          order.fail if not @orders.moves_by_origin(order.dst).nil?
        else # Support === order
          supported_move = @orders.moves_by_origin(order.src)
          
          # supports fail if there is no such move, or if the move of the 
          # unit in the target area moves elsewhere
          if supported_move == nil or not supported_move.dst.eql? order.dst
            order.fail
          end
        end
      when Hold
        # Hold always succeeds
        order.succeed
      when Convoy
        moves = dislodged(order)
        unless moves.nil?
          order.fail
          @logger.debug moves
          @logger.debug "Decision (dislodged): #{order.resolution_readable}"
          return
        end
        
        if @orders.convoyed_move(order).nil?
          order.fail
          @logger.debug "Decision (#{order}): #{order.resolution_readable}"
          return
        end
      
        order.succeed
      end
      @logger.debug "Decision (#{order}): #{order.resolution_readable}"
    end
    
    def check_path(move)
      return true if @map.neighbours?(move.unit_area, move.dst, Area::LAND_BORDER) or @map.neighbours?(move.unit_area, move.dst, Area::SEA_BORDER)
      
      # check convoy path
      related_convoys = @orders.convoys_for_move(move)
      
      @logger.debug "Related convoys: #{related_convoys}"
      
      successful_convoys = related_convoys.reject {|convoy| convoy.failed?}
      
      # see if remaining convoy orders form a path
      ret = check_path_recursive(move, successful_convoys, [move.unit_area])
      @logger.debug "Convoy succeeds? #{ret}"
      ret
    end
    
    def check_path_recursive(move, unused_convoys, last_reached_areas)
      @logger.debug "Unused_convoys: #{unused_convoys}, last_reached_areas: #{last_reached_areas}"
      
      last_reached_areas.each do |area|
        # if we have reached some area bordering the target area, there is a valid path
        return true if @map.neighbours?(area, move.dst, Area::SEA_BORDER)
      end
      
      return false if unused_convoys.empty?
      
      next_reached_areas = []
      
      last_reached_areas.each do |area|
        # collect all convoy areas that border the last reached areas
        # delete the corresponding convoys
        unused_convoys.each do |convoy|
          neighbours = @map.neighbours?(area, convoy.unit_area, Area::SEA_BORDER)
          @logger.debug "Neighbours: #{convoy.unit_area}, #{area}, #{neighbours}"
          if @map.neighbours?(area, convoy.unit_area, Area::SEA_BORDER) and (not next_reached_areas.member? convoy.unit_area)
            next_reached_areas << convoy.unit_area
            unused_convoys.delete(convoy)
          end
        end
      end
      
      @logger.debug "next_reached_areas: #{next_reached_areas}"
      
      # areas in next_reached_areas might not be unique
      next_reached_areas.uniq!
      
      # if we reached no new areas, fail
      return false if next_reached_areas.empty?
      
      check_path_recursive(move, unused_convoys, next_reached_areas)
    end
    
    def calculate_attack_strength(move)
      # if the move path is not successful, strength is 0
      return 0 unless check_path(move)
      
      strength = 1
      
      unit_at_dst = @state.area_unit(move.dst)
      
      # use this to determine if unit leaving - can only be zero or one
      dst_move = @orders.moves_by_origin(move.dst)
      
      if unit_at_dst == nil or ( (not dst_move.nil?) and dst_move.succeeded? )
        # destination is empty or the unit at the destination successfully moves away
        supports = @orders.supports_by_dst(move.dst)
        
        supports.each do |support|
          if support.src == move.unit_area and 
              support.succeeded?
            strength += 1
          end
        end
      else
        # destination is not empty and didn't move away
        if unit_at_dst.nationality == move.nationality
          return 0 # no friendly fire in this game
        else
          supports = @orders.supports_by_dst(move.dst)
          
          supports.each do |support|
            if support.src == move.unit_area and 
                support.nationality != unit_at_dst.nationality and 
                support.succeeded?
              strength += 1
            end
          end
        end
      end
      
      return strength
    end
    
    def calculate_defend_strength(move)
      strength = 1
      supports = @orders.supports_by_dst(move.dst)
      
      supports.each do |support|
        if support.src == move.unit_area and 
            support.succeeded?
          strength += 1
        end
      end
      
      return strength
    end
    
    def calculate_prevent_strength(move)
      # if the move path is not successful, strength is 0
      return 0 unless check_path(move)
      
      strength = 1
      supports = @orders.supports_by_dst(move.dst)
      
      # FIXME some ambiguity regarding prevent strength and defend strength
      supports.each do |support|
        if support.src == move.unit_area and 
            support.succeeded?
          strength += 1
        end
      end
      
      return strength
    end
    
    def calculate_hold_strength(area)
      if not (unit_at_dst = @state.area_unit(area)).nil?
        # use this to determine if unit leaving
        dst_move = @orders.moves_by_origin(area)
        
        if (not dst_move.nil?) # unit was ordered to move
          strength = 0 if dst_move.succeeded?
          strength = 1 if dst_move.failed?
        else # unit was ordered something supportable
          strength = 1
          
          supports = @orders.supportholds_to(area)
          
          supports.each do |support|
            strength += 1 if support.succeeded?
          end
        end
      else # there is no unit
        strength = 0
      end
      
      return strength
    end
    
    def dislodged(order)
      if !(Move === order) || order.failed?
        return @orders.moves_by_dst(order.unit_area).detect {|move| move.succeeded? }
      end
    end
    
    def guess_resolve!(loop)
      @logger.debug "Entered guess_resolve! for loop: #{loop}"
      @loop = true
      return if loop.empty?
      
      resolutions = []
      
      head = loop[0]
      tail = loop[1..-1].reverse
      
      @logger.debug "Guessing negative for #{head.to_s}"
      head.guess(Diplomacy::FAILURE)
      tail.each do |order|
        resolve_order!(order)
      end
      
      head.unresolve
      adjudicate!(head)
      @logger.debug "Guess result: #{head.status_readable}"
      
      @logger.debug tail.collect { |order| "#{order.to_s} #{order.status_readable}" }
      
      resolutions << (head.resolution == Diplomacy::FAILURE)
      
      # now clear and guess positive
      clear_orders!(tail)
      
      @logger.debug "Guessing positive for #{head.to_s}"
      head.guess(Diplomacy::SUCCESS)
      tail.each do |order|
        resolve_order!(order)
      end
      
      head.unresolve
      adjudicate!(head)
      @logger.debug "Guess result: #{head.status_readable}"
      
      @logger.debug tail.collect { |order| "#{order.to_s} #{order.status_readable}" }
      
      resolutions << (head.resolution == Diplomacy::SUCCESS)
      
      @logger.debug "Guess resolutions: #{resolutions}"
      
      clear_orders!(tail)
      
      if (consistent = resolutions[0] ^ resolutions[1])
        head.resolution = resolutions[0] ? Diplomacy::FAILURE : Diplomacy::SUCCESS
        head.resolve
        
        # hm. might be better to store them
        tail.each do |order|
          resolve_order!(order)
        end
      end
      
      @loop = false
      
      consistent
    end
    
    def clear_orders!(orders)
      orders.each do |order|
        order.unresolve
      end
    end

    def resolve_retreats!(state, unchecked_retreats, adjust=false)
      validator = Validator.new(state, @map, unchecked_retreats, [Retreat])
      @retreats, invalid_retreats = validator.validate_orders(false)

      @retreats.retreats.each do |area, retreats|
        if retreats.length == 1 and
          (not state[area].embattled) and
          (not retreats[0].dst == state.dislodge_attacker_origin(retreats[0]))

          retreats[0].succeed
        else
          retreats.each {|r| r.fail }
        end
      end

      reconcile!(@retreats.orders, invalid_retreats)

      state.apply_retreats! @retreats.orders

      state.adjust!(@map) if adjust

      return state, @retreats.orders
    end

    def resolve_builds!(state, unchecked_builds)
      validator = Validator.new(state, @map, unchecked_builds, [Build])
      @builds, invalid_builds = validator.validate_orders(false)

      @builds.orders.each {|build| build.succeed unless build.nil? }

      reconcile!(@builds.orders, invalid_builds)

      state.apply_builds! @builds.orders

      return state, @builds.orders
    end

    def reconcile!(resolved_orders, invalid_orders)
      resolved_orders.each_index do |index|
        if (not resolved_orders[index].nil?) and resolved_orders[index].unresolved?
          @logger.warn "ORDER NEVER RESOLVED! (#{resolved_orders[index]})"
        end
        resolved_orders[index] = invalid_orders[index] if invalid_orders[index]
      end
    end
  end
end
