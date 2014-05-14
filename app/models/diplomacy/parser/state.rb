require_relative '../adjudicator/state'
require_relative '../entity/unit'

module Diplomacy
  class Parser::State

    def initialize( gamestate = nil )
      @gamestate = gamestate || GameState.new
    end

    def from_json( data )
      to_state JSON.parse data
    end

    def to_state( data )
      @gamestate = GameState.new

      data['Powers'].each do |power, state|
        power_s = power.to_sym

        state['Units'].each do |force|
          if /^([AF])(\w{3})(_\w{2})?(?:\<(\w{3}))?$/ =~ force
            unit = Unit.new power_s, $1 == 'A' ? Unit::ARMY : Unit::FLEET
            area = $2.to_sym

            if $4
              @gamestate.dislodges[area] = DislodgeTuple.new unit, $4.to_sym
            else
              @gamestate[area] = AreaState.new nil, unit, $3
            end
          end
        end

        state['Areas'].each do |land|
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
      data = {}

      powers = {}
      @gamestate.each do |name, area|
        if unit = area.unit
          ( powers[unit.nationality] ||= Parser::State.empty_power )[:Units] <<
          unit_to_string( unit, "#{name}#{area.coast}" )
        end
        if area.owner
          ( powers[area.owner] ||= Parser::State.empty_power )[:Areas] << name
        end
      end

      unless @gamestate.dislodges.empty?
        @gamestate.dislodges.each do |name, dislodge|
          ( powers[dislodge.unit.nationality] ||= [] )[:Units] <<
          dislodge_to_string( name, dislodge )
        end
        data[:Embattled] = @gamestate.embattled
      end

      data[:Powers] = powers

      data.to_json
    end

    private

    def unit_to_string(unit, area)
      "#{unit.type_to_s}#{area}"
    end

    def dislodge_to_string(area, dislodge_tuple)
      "#{unit_to_string(dislodge_tuple.unit, area)}<#{dislodge_tuple.origin_area}"
    end

    def self.empty_power
      { :Units => [], :Areas => [] }
    end
  end
end
