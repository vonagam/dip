require 'set'

module Engine
  class Area
    attr_accessor :abbrv, :type, :supply_center, :name, :multicoast
    attr_accessor :borders, :neighbours

    LAND_BORDER = 1
    SEA_BORDER = 2

    def initialize( abbrv, type, supply_center, neighbours, name, multicoast )
      @abbrv = abbrv
      @type = type
      @supply_center = supply_center
      @name = name

      @neighbours = neighbours

      @borders = { LAND_BORDER => Set.new, SEA_BORDER => Set.new }

      @multicoast = multicoast #vonagam: for fleet build validation        
    end

    def add_border( area, border_type )
      borders[border_type] << area
    end

    def is_land?
      @type != :water
    end
    
    def is_coastal?
      @type == :coast
    end
  end
end
