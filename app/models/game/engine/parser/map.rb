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

      map.yaml_areas = yamlmap['Areas']

      yamlmap['Areas'].each do |name, info|

        if info['neis'].is_a?(Array)
          neighbours = info['neis']
        else
          neighbours = info['neis']['xc']

          info['neis'].select { |k,v| k != 'xc' }.each do |location, neis|
            location_name = ("#{name}_#{location}").to_sym
            map.areas[location_name] = Area.new(
              location_name, :coast, false, neis, info['full'].to_sym, false
            )
          end
        end

        map.areas[name.to_sym] = Area.new(
          name.to_sym,
          info['type'].to_sym,
          info.has_key?('center'),
          neighbours,
          info['full'].to_sym,
          !info['neis'].is_a?(Array)
        )

      end

      map.areas.each do |name, area|

        while nei = area.neighbours.pop

          neighbour = map.areas[ nei.to_sym ]

          ( 
            if area.type == :water || neighbour.type == :water
              [Area::SEA_BORDER]
            elsif area.type == :land || neighbour.type == :land
              [Area::LAND_BORDER]
            else
              [Area::SEA_BORDER, Area::LAND_BORDER]
            end
          )
          .each do |type|
            area.add_border neighbour, type

            if nei =~ /\A(\w+)_/
              area.add_border map.areas[ $1.to_sym ], type
            end
          end

        end

      end

      map.powers = yamlmap['Powers'].keys

      map.starting_state = Parser::State.new().to_state({ 'Powers' => yamlmap['Powers'] })
      
      @maps[mapname] = map
    end
  end
end
