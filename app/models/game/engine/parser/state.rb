require_relative '../adjudicator/state'
require_relative '../entity/unit'

module Engine
  class Parser::State

    def initialize( gamestate = nil )
      @gamestate = gamestate || GameState.new
    end

    def to_state( data )
      @gamestate = GameState.new

      data['Powers'].each do |power, state|
        power_s = power.to_sym

        state['Units'].each do |force|
          if /^([AF])(\w{3})(_\w{2})?(?:-(\w{3}))?$/ =~ force
            unit = Unit.new power_s, $1 == 'A' ? Unit::ARMY : Unit::FLEET
            area = $2.to_sym

            if $4
              @gamestate.dislodges[area] = DislodgeTuple.new unit, $4.to_sym
            else
              @gamestate[area].unit = unit
              @gamestate[area].coast = $3
            end
          end
        end

        state['Areas'].each do |land|
          @gamestate[land.to_sym].owner = power_s
        end
      end

      if data.has_key?('Embattled')
        data['Embattled'].each do |land|
          @gamestate[land.to_sym].embattled = true
        end
      end

      @gamestate
    end

    def to_hash
      data = { Powers: Hash.new { |h,k| h[k] = Parser::State.empty_power } }

      powers = data[:Powers]

      @gamestate.each do |name, area|
        if unit = area.unit
          powers[unit.nationality][:Units] <<
          unit_to_string(unit, "#{name}#{area.coast}")
        end
        if area.owner
          powers[area.owner][:Areas] << name
        end
      end

      unless @gamestate.dislodges.empty?
        @gamestate.dislodges.each do |name, dislodge|
          powers[dislodge.unit.nationality][:Units] <<
          dislodge_to_string(dislodge, name)
        end
        data[:Embattled] = @gamestate.embattled
      end

      data
    end

    private

    def unit_to_string(unit, area)
      "#{unit.type_to_s}#{area}"
    end

    def dislodge_to_string(dislodge_tuple, area)
      "#{unit_to_string(dislodge_tuple.unit, area)}-#{dislodge_tuple.origin_area}"
    end

    def self.empty_power
      { :Units => [], :Areas => [] }
    end
  end
end
