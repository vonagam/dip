require 'diplomacy/adjudicator/adjudicator'

MAP_READER = Diplomacy::Parser::Map.new
ADJUDICATOR = Diplomacy::Adjudicator.new MAP_READER.maps['Standard']

MAP_READER.maps.each do |name, data|
  Map.find_or_create_by name: name
end
