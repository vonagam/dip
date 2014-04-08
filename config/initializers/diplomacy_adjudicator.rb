require 'diplomacy/adjudicator/adjudicator'

::MAP_READER = Diplomacy::Parser::Map.new
::ADJUDICATOR = Diplomacy::Adjudicator.new ::MAP_READER.maps['Standard']
