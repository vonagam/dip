require 'yaml'
require 'set'
require_relative '../entity/area'
require_relative '../entity/map'

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

            ( 
              if area.type == 'water' || neighbour.type == 'water'
                [Area::SEA_BORDER]
              elsif area.type == 'land' || neighbour.type == 'land'
                [Area::LAND_BORDER]
              else
                [Area::SEA_BORDER, Area::LAND_BORDER]
              end
            )
            .each do |type|
              area.add_border neighbour, type
            end

          end

        end

        map.powers = yamlmap['Powers'].keys

        map.starting_state = Parser::State.new().to_state({ 'Powers' => yamlmap['Powers'] })
        
        @maps[mapname] = map
      end
    end
  end
end
