require 'logger'

require_relative 'state'
require_relative '../graph/graph'

module Diplomacy 
  UNRESOLVED = 0
  GUESSING = 1
  RESOLVED = 2
  
  SUCCESS = 0
  FAILURE = 1
  INVALID = 2

  class GenericOrder
    attr_accessor :unit, :unit_area, :dst, :status, :resolution, :unit_area_coast, :dst_coast
    def initialize(unit, unit_area, dst)
      @logger = Diplomacy.logger
      @unit = unit
      @unit_area = unit_area
      @dst = dst
      @status = UNRESOLVED
      @resolution = FAILURE
    end
    # affected area
    def affected
      dst
    end
    
    def unit_area_with_coast
      (unit_area.to_s + unit_area_coast.to_s).to_sym
    end
    
    def dst_with_coast
      (dst.to_s + dst_coast.to_s).to_sym
    end
    
    def resolve
      @status = RESOLVED
    end
    
    def succeed
      resolve
      @resolution = SUCCESS
    end
    
    def fail
      resolve
      @resolution = FAILURE
    end
    
    def invalidate
      resolve
      @resolution = INVALID
    end
    
    def guess(guess)
      @status = GUESSING
      @resolution = guess
    end
    
    def unresolve
      @status = UNRESOLVED
    end
    
    def nationality
      unit.nationality
    end
    
    def resolved?
      @status == RESOLVED
    end
    
    def unresolved?
      @status == UNRESOLVED
    end
    
    def guessing?
      @status == GUESSING
    end
    
    def failed?
      @logger.debug "UNRESOLVED ORDER! (#{to_s})"if unresolved?
      @resolution == FAILURE
    end
    
    def succeeded?
      @logger.debug "UNRESOLVED ORDER! (#{to_s})"if unresolved?
      @resolution == SUCCESS
    end
    
    def invalid?
      @resolution == INVALID
    end
    
    def status_readable
      case @status
      when UNRESOLVED
        stat_str = "UNRESOLVED"
      when GUESSING
        stat_str = "GUESSING #{resolution_readable}"
      when RESOLVED
        stat_str = "#{resolution_readable}"
      end
      stat_str
    end
    
    def resolution_readable
      case @resolution
      when SUCCESS
        res_str = "SUCCESS"
      when FAILURE
        res_str = "FAILURE"
      when INVALID
        res_str = "INVALID"
      end
      res_str
    end
    
    def prefix
      "#{@unit.nil? ? 'X' : @unit.type_to_s} #{unit_area.to_s}"
    end
  end

  class Hold < GenericOrder
    def initialize(unit, unit_area)
      super(unit, unit_area, unit_area)
    end
    
    def to_s
      "#{prefix} H"
    end
  end

  class Move < GenericOrder
    def to_s
      "#{prefix} -> #{@dst}"
    end
  end

  class Support < GenericOrder
    attr_accessor :src, :src_coast

    def initialize(unit, unit_area, src, dst)
      super(unit, unit_area, dst)
      @src = src
    end
    
    def to_s
      "#{prefix} S #{@src.to_s}#{@src_coast} -> #{@dst}#{dst_coast}"
    end
  end

  class SupportHold < GenericOrder
    def to_s
      "#{prefix} S #{@dst} H"
    end
  end

  class Convoy < GenericOrder
    attr_accessor :src, :src_coast
    def initialize(unit, unit_area, src, dst)
      super(unit, unit_area, dst)
      @src = src
    end
    
    def to_s
      "#{prefix} C #{@src} -> #{@dst}"
    end
  end

  class Retreat < GenericOrder
    def initialize(unit, unit_area, dst)
      super(unit, unit_area, dst)
    end

    def to_s
      "R #{prefix} -> #{@dst}"
    end
  end

  class Build < GenericOrder
    attr_accessor :build
    def initialize(unit, unit_area, build=true)
      super(unit, unit_area, nil)
      @build = build
    end

    def to_s
      "#{@build ? 'B' : 'D'} #{prefix}"
    end
  end

  class OrderCollection
    attr_accessor :orders
    attr_accessor :moves
    attr_accessor :supports
    attr_accessor :supportholds
    attr_accessor :holds
    attr_accessor :convoys
    attr_accessor :retreats
    attr_accessor :builds
    
    def initialize(orders)
      @orders = []
      @moves = {}
      @supports = {}
      @holds = {}
      @supportholds = {}
      @convoys = {}
      @retreats = {}
      @builds = {}
 
      process_orders(orders)
    end

    def process_orders(orders)
      # create wrappers and categorize orders
      orders.each do |order|
        case order
        when Move
          (self.moves[order.dst] ||= Array.new) << order
        when Support
          (self.supports[order.dst] ||= Array.new) << order
        when Hold 
          (self.holds[order.dst] ||= Array.new) << order
        when SupportHold
          (self.supportholds[order.dst] ||= Array.new) << order
        when Convoy
          (self.convoys[order.dst] ||= Array.new) << order
        when Retreat
          (self.retreats[order.dst] ||= Array.new) << order
        when Build
          (self.builds[order.unit_area] ||= Array.new) << order
        end
        @orders << order
      end
    end
    
    def each(&blk)
      @orders.each(&blk)
    end
    
    def convoys_for_move(move)
      convoys_to_area = @convoys[move.dst]
      if convoys_to_area.nil?
        return []
      end
      
      return convoys_to_area.find_all { |convoy| convoy.src.eql? move.unit_area }
    end
    
    def moves_by_dst(area, skip_me=false, me=nil)
      moves = @moves[area] || []
      
      if skip_me
        moves.reject {|move| move.equal? me}
      else
        moves
      end
    end
    
    def supports_by_dst(area)
      supports = @supports[area] || []
    end
    
    def supported_move(support)
      candidate = moves_by_origin(support.src)
      if candidate && (candidate.dst.eql? support.dst)
        return candidate
      else
        return nil
      end
    end
    
    def moves_by_origin(area)
      @moves.values.each do |moves_for_area|
        # only one at most can exist, so detect is enough
        if not (ret = moves_for_area.detect { |move| move.unit_area.eql? area }).nil?
          return ret
        end
      end
      
      # no compyling move was found, return nil
      return nil
    end
    
    def hold_in(area)
      hold = @holds[area] || []
    end
    
    def supportholds_to(area)
      supports = @supportholds[area] || []
    end
    
    def convoyed_move(convoy)
      supported_move(convoy) # works exactly as this one should
    end
    
    def remove(order)
      # if object not found in @orders, don't try to find it anywhere else
      if @orders.delete(order)
        case order
        when Move
          self.moves[order.dst].delete(order)
        when Support
          self.supports[order.dst].delete(order)
        when Hold 
          self.holds[order.dst].delete(order)
        when SupportHold
          self.supportholds[order.dst].delete(order)
        when Convoy
          self.convoys[order.dst].delete(order)
        end
      end
    end
  end
end
