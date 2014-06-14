require 'rails_helper'

describe Map do
  it '#json_deep' do
    @map = Map.find_by name: 'Standart'
    puts @map.info.yaml_areas
  end
end
