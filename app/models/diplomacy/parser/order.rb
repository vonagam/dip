require_relative '../adjudicator/orders'

module Diplomacy
  class Parser::Order
    def initialize( gamestate )
      @gamestate = gamestate
    end

    def parse_orders( all_orders, classes=[Move, Hold, Support, SupportHold, Convoy] )
      result = []

      all_orders.each do | power_orders |
        power = power_orders.side.power.to_sym
        orders = JSON.parse power_orders.data

        orders.each do | region, order |
          order = parse_order region, order, power

          next if order.nil? || classes.not_include?(order.class)

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
      position, position_coast = parse_location region
      from, from_coast = parse_location order['from']
      to, to_coast = parse_location order['to']

      area = @gamestate[position]
      unit = area.unit

      if unit.nil?
        return nil unless order['type'] == 'Build' && area.owner == power
      else
        return nil if unit.nationality != power
        position_coast = area.coast
      end

      result = 
      case order['type']
      when 'Hold';    Hold.new unit, position
      when 'Move';    Move.new unit, position, to
      when 'Convoy';  Convoy.new unit, position, from, to
      when 'Retreat'; Retreat.new unit, position, to   
      when 'Disband'; Build.new unit, position, false
      when 'Support'
        if from == to
          SupportHold.new unit, position, to
        else
          Support.new unit, position, from, to
        end
      when 'Build'
        return nil if area.owner != power
        unit = Unit.new power, (order['unit'] == 'army' ? Unit::ARMY : Unit::FLEET)
        Build.new unit, position, true 
      else
        nil
      end

      result.unit_area_coast = position_coast
      result.dst_coast = to_coast
      result.src_coast = from_coast if result.respond_to?(:src_coast)

      order[:region] = region
      order[:power] = power
      result.origin = order

      return result
    end
  end
end
