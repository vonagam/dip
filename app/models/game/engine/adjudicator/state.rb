module Engine

  class AreaState
    attr_accessor :owner, :unit, :coast, :embattled

    def initialize(owner=nil, unit=nil, coast=nil, embattled=false)
      @owner = owner
      @unit = unit
      @coast = coast
      @embattled = embattled
    end

    def conquer
      @owner = @unit.nationality unless @unit.nil?
    end

    def ==(other)
      return (@owner == other.owner and @unit == other.unit) #and @coast == other.coast)
    end
  end

  class GameState < Hash
    attr_accessor :dislodges

    def initialize
      self.default_proc = proc {|this_hash, nonexistent_key| this_hash[nonexistent_key] = AreaState.new }
      @dislodges = {}
    end

    def area_state(area)
      if Area === area
        self[area.abbrv] || (self[area.abbrv] = AreaState.new)
      elsif Symbol === area
        self[area] || (self[area] = AreaState.new)
      end
    end

    def dislodge_state(area)
      if Area === area
        @dislodges[area.abbrv] || DislodgeTuple.new(nil, nil)
      elsif Symbol === area
        @dislodges[area] || DislodgeTuple.new(nil, nil)
      end
    end

    def embattled
      (self.select {|area, area_state| area_state.embattled }).keys
    end

    def area_unit(area)
      area_state(area).unit
    end

    def set_area_unit(area, unit)
      area_state(area).unit = unit
    end

    def dislodge_attacker_origin(dislodge_order)
      dislodge_state(dislodge_order.unit_area).origin_area
    end

    def apply_orders!(orders)
      succeeded_movers = []
      orders.each do |order|
        if Move === order
          # mark area embattled for all moves - it will only matter in empty areas
          self[order.dst].embattled = true

          if order.succeeded?
            area_from = order.unit_area
            unit = area_unit area_from

            unit.order = order
            succeeded_movers << unit

            set_area_unit area_from, nil
          end
        end
      end
      succeeded_movers.each do |mover|
        order = mover.order

        if unit = area_unit(order.dst)
          @dislodges[order.dst] = DislodgeTuple.new(unit, order.unit_area)
        end

        set_area_unit order.dst, mover
        area_state( order.dst ).coast = order.dst_coast
      end
    end

    def apply_retreats!(retreats)
      retreats.each do |r|
        set_area_unit(r.dst, @dislodges[r.unit_area].unit) if r.succeeded?
        # do nothing about the failed ones, they will be discarded
      end
      @dislodges = {}
    end

    def apply_builds!(builds, map)
      powers = {}
      map.powers.each do |power|
        powers[power.to_sym] = { supplies: 0, units: [] }
      end
      self.each do |abbrv, area_state|
        if area_state.owner && map.areas[abbrv].supply_center
          powers[ area_state.owner ][:supplies] += 1
        end
        if area_state.unit
          powers[ area_state.unit.nationality ][:units] << abbrv
        end
      end

      builds.each do |b|
        next unless b.succeeded?

        power = powers[b.unit.nationality]

        if b.build
          if power[:supplies] > power[:units].size
            set_area_unit b.unit_area, b.unit
            power[:units] << b.unit_area
          end
        else
          if power[:units].size > power[:supplies]
            set_area_unit b.unit_area, nil
            power[:units].delete b.unit_area
          end 
        end
      end

      powers.each do |power, stat|
        while stat[:supplies] < stat[:units].size
          abbrv = stat[:units].delete_at rand stat[:units].size
          set_area_unit abbrv, nil
        end
      end
    end

    def adjust!(map)
      self.each do |abbrv, area_state|
        area_state.conquer if map.areas[abbrv].is_land?
      end
    end

    def ==(other)
      return false if other.keys() != self.keys()
      self.each do |k, v|
        return false if other[k] != v
      end
      return true
    end
  end

  class DislodgeTuple
    attr_accessor :unit
    attr_accessor :origin_area

    def initialize(unit, origin_area)
      @unit = unit
      @origin_area = origin_area
    end
  end
end
