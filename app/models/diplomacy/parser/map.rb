require 'yaml'
require 'set'

module Diplomacy
  class Parser::Map
    attr_accessor :maps
    
    def initialize()
      @maps = {}

      map_path ||= File.expand_path('../maps/', File.dirname(__FILE__))

      Dir.chdir map_path do
        Dir.glob "*.yaml" do |mapfile|
          read_map_file mapfile
        end
      end
    end
    
    def read_map_file(yaml_file)
      yamlmaps = YAML::load_file yaml_file
      
      yamlmaps.each do |mapname, yamlmap|

        map = Map.new

        yamlmap['Areas'].each do |name, info|

          if info['type'] != 'multi_coast'
            neighbours = info['neis']
          else
            neighbours = info['neis']['xc']

            info['neis'].select { |k,v| k != 'xc' }.each do |location, neis|
              location_name = ("#{name}_#{location}").to_sym
              map.areas[location_name] = Area.new(
                location_name, 'coast', false, neis, info['full'].to_sym
              )
            end
          end

          map.areas[name.to_sym] = Area.new(
            name.to_sym,
            info['type'].to_sym,
            info.has_key?('center'),
            neighbours,
            info['full'].to_sym
          )

        end

        map.areas.each do |name, area|

          while nei = area.neighbours.pop

            neighbour = map.areas[ nei.to_sym ]

            border_type = [Area::SEA_BORDER, Area::LAND_BORDER]

            if area.type == 'water' || neighbour.type == 'water'
              border_type.pop
            elsif area.type == 'land' || neighbour.type == 'land'
              border_type.shift
            else

            border_type.each do |type|
              add_border area, neighbour, type
            end

          end

        end

      	yamlmap['Powers'].each do |power, start|
          state_parser = StateParser.new

          power_s = power.to_sym

          gamestate = state_parser.parse_power_state start, power_s

          gamestate.each_value { |area_state| area_state.owner = power_s }

          start['L'].each do |area|
            gamestate[area.to_sym] = AreaState.new power.to_sym
          end

          map.add_power power_s, gamestate
      	end
        
        @maps[mapname] = map
      end
    end
  end

  class Area
    attr_accessor :name, :type, :center, :full_name
    attr_accessor :borders, :coasts, :neighbours

    LAND_BORDER = 1
    SEA_BORDER = 2

    def initialize( name, type, center, neighbours, full_name )
      @name = name
      @type = type
      @center = center
      @full_name = full_name

      @neighbours = neighbours

      @borders = { LAND_BORDER => Set.new, SEA_BORDER => Set.new }
      @coasts = []
    end

    def add_border( area, border_type )
      borders[border_type] << area
    end
  end

  class Map
    attr_accessor :areas, :powers

    def initialize
      @areas = {}
      @powers = {}
    end

    def add_power( name, starting_areas )
      @powers[name] = starting_areas
    end

    def add_border( area1, area2, type )
      area1.add_border area2, type
      area2.add_border area1, type
    end
    
    def neighbours?( name1, name2, type )
      @areas[name1].borders[type].include? @areas[name2]
    end

    def centers
      @areas.select { |name, area| area.center }
    end

    def starting_state
      gamestate = GameState.new

      @areas.each do |area|
        gamestate[area] = AreaState.new
      end

      @powers.each_value do |power_gamestate|
        gamestate.merge! power_gamestate
      end
      
      gamestate
    end
  end
end
