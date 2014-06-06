module Engine
  class Map
    attr_accessor :areas, :powers, :initial_state, :yaml_areas

    def initialize
      @areas = {}
      @powers = []
    end
    
    def neighbours?( name1, name2, type )
      @areas[name1].borders[type].include? @areas[name2]
    end

    def supply_centers
      @areas.select { |name, area| area.supply_center }
    end
  end
end
