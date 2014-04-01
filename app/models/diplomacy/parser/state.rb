module Diplomacy
  class Parser::State

    def initialize( gamestate = nil )
      @gamestate = gamestate || GameState.new
    end

    def to_state( data )
      @gamestate = GameState.new

      data['Powers'].each do |power, state|
        power_s = power.to_sym

        state['Force'].each do |force|
          if /^([AF])(\w{3})(?:\_(\w{2}))?(?:\<(\w{3}))?$/ =~ force
            unit = Unit.new power_s, $1 == 'A' ? Unit::ARMY : Unit::FLEET
            area = $2.to_sym

            if $4
              @gamestate.dislodges[area] = DislodgeTuple.new unit, $4.to_sym
            else
              @gamestate[area] = AreaState.new nil, unit, $3
            end
          end
        end

        state['Lands'].each do |land|
          ( @gamestate[land.to_sym] ||= AreaState.new ).owner = power_s
        end

      end

      if data.has_key?( 'Embattled' )
        data['Embattled'].each do |land|
          ( @gamestate[land.to_sym] ||= AreaState.new ).embattled = true
        end
      end

      @gamestate
    end

    def to_json
      powers = {}

      @gamestate.each do |name, area|
        
        if unit = area.unit
          ( powers[unit.nationality] ||= StateParser.empty_power )[:Force] <<
          unit_to_string( unit, "#{name}#{ area.coast && "_#{area.coast}" }" )
        end

        if area.owner
          ( powers[area.owner] ||= StateParser.empty_power )[:Lands] << name
        end

      end

      @gamestate.dislodges.each do |name, dislodge|
        ( powers[dislodge.unit.nationality] ||= StateParser.empty_power )[:Force] <<
        dislodge_to_string( name, dislodge )
      end

      { :Powers => powers, :Embattled => @gamestate.embattled || [] }
    end

    private

    def unit_to_string(unit, area)
      "#{unit.type_to_s}#{area}"
    end

    def dislodge_to_string(area, dislodge_tuple)
      "#{dump_unit(dislodge_tuple.unit, area)}<#{dislodge_tuple.origin_area}"
    end

    def self.empty_power
      { :Force => {}, :Lands => [] }
    end
  end
end
