require_relative '../adjudicator/orders'

module Engine
  class Parser::Order
    def initialize( gamestate )
      @gamestate = gamestate
    end

    def parse_orders( powers_orders, state_type )
      classes = case state_type
        when 'Move'    then [Move, Hold, Support, SupportHold, Convoy]
        when 'Retreat' then [Retreat]
        when 'Supply'  then [Build]
      end

      result = []

      powers_orders.each do |power, orders|
        power = power.to_sym

      #all_orders.each do | power_orders |
      #  power = power_orders.side.power.to_sym
      #  orders = power_orders.data

        orders.each do | region, order |
          order = parse_order region, order, power, state_type

          next if order.nil? || classes.not_include?( order.class )

          result << order
        end
      end

      result
    end

    private

    def parse_location( region )
      return nil if region.nil?
      location = region.split(/(?=_)/)
      location[0] = location[0].to_sym
      return location
    end

    def parse_order( region, order, power, state_type )
      position, position_coast = parse_location region
      from, from_coast = parse_location order['from']
      to, to_coast = parse_location order['to']

      area = @gamestate[position]

      unit = case state_type
        when 'Retreat' then @gamestate.dislodges[ position ].unit
        else area.unit
      end

      if unit.nil?
        return nil unless order['type'] == 'Build' && area.owner == power
      else
        return nil if unit.nationality != power
        position_coast = area.coast
      end

      result = 
      case order['type']
      when 'Hold';    Hold.new    unit, position
      when 'Move';    Move.new    unit, position, to
      when 'Convoy';  Convoy.new  unit, position, from, to
      when 'Retreat'; Retreat.new unit, position, to   
      when 'Disband'; Build.new   unit, position, false
      when 'Support'
        if from == to
          SupportHold.new unit, position, to
        else
          Support.new unit, position, from, to
        end
      when 'Build'
        unit = Unit.new power, (order['unit'] == 'army' ? Unit::ARMY : Unit::FLEET)
        Build.new unit, position, true 
      else
        return nil
      end

      result.unit_area_coast = position_coast
      result.dst_coast = to_coast
      result.src_coast = from_coast if result.respond_to?(:src_coast)

      result.raw = { region: region, power: power, order: order }

      return result
    end
  end
end
