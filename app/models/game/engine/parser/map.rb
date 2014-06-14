require 'yaml'
require 'set'
require_relative '../entity/area'
require_relative '../entity/map'

module Engine
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
      yamlmap = YAML::load_file yaml_file

      mapname = yaml_file.scan(/\A[^.]+/)[0].classify

      map = Map.new

      map.yaml_areas = yamlmap['Areas'].to_json

      borders_infos = {}

      yamlmap['Areas'].each do |name, info|

        neis = info['neis']

        multicoast = neis.has_key?('water') && neis['water'].is_a?(Hash)

        if multicoast
          neis['water'].each do |location, water_neis|
            location_name = ("#{name}_#{location}").to_sym

            map.areas[location_name] = Area.new(
              location_name, :coast, false, info['full'].to_sym, false
            )

            borders_infos[ location_name ] = { 'water' => water_neis }
          end

          neis.delete 'water'
        end

        map.areas[name.to_sym] = Area.new(
          name.to_sym,
          info['type'].to_sym,
          info.has_key?('center'),
          info['full'].to_sym,
          multicoast
        )

        borders_infos[ name.to_sym ] = neis

      end

      borders_infos.each do |area_name, borders_info|
        areas = [ map.areas[ area_name ] ]

        if area_name =~ /\A(\w+)_/
          areas.push map.areas[ $1.to_sym ]
        end

        areas.each do |area|
          borders_info.each do |type, neighbours|
            border_type = type == 'land' ? Area::LAND_BORDER : Area::SEA_BORDER

            neighbours.each do |neighbour|
              area.add_border map.areas[ neighbour.to_sym ], border_type

              if neighbour =~ /\A(\w+)_/
                area.add_border map.areas[ $1.to_sym ], border_type
              end
            end
          end
        end
      end

      map.powers = yamlmap['Powers'].keys

      map.initial_state = Parser::State.new().to_state({ 'Powers' => yamlmap['Powers'] })
      
      @maps[mapname] = map
    end
  end
end
