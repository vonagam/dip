module Diplomacy
  class Parser::Order
    def initialize( gamestate )
      @gamestate = gamestate
    end

    def parse_orders( all_orders, classes=[Move, Hold, Support, SupportHold, Convoy] )
      result = []

      all_orders.each do | power_orders |
        power = power_orders.side.name.to_sym
        orders = JSON.parse order.data

        orders.each do | region, order |
          order = parse_order region, order, power

          next if order.nil?
          #  raise 
          #end

          next if classes.not_include? order.class
          #  raise WrongOrderTypeError, "expected one of #{classes}, received #{order.class}"
          #end

          result << order
        end
      end

      result
    end

    def parse_retreats( orders )
      parse_orders orders, [Retreat]
    end
    def parse_builds( orders )
      parse_orders orders, [Build]
    end

    private

    def parse_location( region )
      return nil if region.nil?
      location = region.split(/(?=_)/)
      location[0] = location[0].to_sym
      return location
    end

    def parse_order( region, order, power )
      position = parse_location region
      from = parse_location order['from']
      to = parse_location order['to']

      location = position.first
      dst = to.first
      src = from.first

      area = @gamestate[position]
      unit = area.unit

      return nil if unit.not_nil? && unit.owner != power

      result = 
      case order['type']
      when 'hold';    Hold.new unit, location
      when 'move';    Move.new unit, location, dst
      when 'convoy';  Convoy.new unit, location, src, dst
      when 'retreat'; Retreat.new unit, location, dst   
      when 'disband'; Build.new unit, location, false
      when 'support'
        if from
          Support.new unit, location, src, dst
        else
          SupportHold.new unit, location, dst
        end
      when 'build'
        return nil if area.owner != power
        unit = Unit.new power, (order['build'] == 'army' ? Unit::ARMY : Unit::FLEET)
        Build.new unit, location, true 
      else
        nil
      end

      result.unit_area_coast = position[1] if position.length == 2
      result.dst_coast = to[1] if to.length == 2
      result.src_coast = from[1] if from.length == 2

      return result
    end
  end
end
