module Diplomacy
  class Map
    attr_accessor :areas, :starting_state

    def initialize
      @areas = {}
    end

    def add_power( name, starting_areas )
      @powers[name] = starting_areas
    end
    
    def neighbours?( name1, name2, type )
      @areas[name1].borders[type].include? @areas[name2]
    end

    def supply_centers
      @areas.select { |name, area| area.center }
    end
  end
end
