module Diplomacy
  class Unit
    ARMY = 1
    FLEET = 2

    attr_accessor :nationality
    attr_accessor :type

    def initialize(nationality=nil, type=nil)
      @nationality = nationality
      @type = type
    end

    def is_army?
      type == ARMY
    end

    def is_fleet?
      type == FLEET
    end

    def type_to_s
      return "A" if is_army?
      return "F" if is_fleet?
      return "Unknown"
    end

    def ==(other)
      return ((not other.nil?) and @nationality == other.nationality and @type == other.type)
    end
  end
end
