require 'diplomacy/parser/map'

MAP_READER = Diplomacy::Parser::Map.new

MAP_READER.maps.each do |map_name, map|
  Map.find_or_create_by name: map_name
end
