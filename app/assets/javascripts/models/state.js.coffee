modulejs.define 'm.State', 
  [
    'm.Base'
    'm.g.Area'
    'm.g.Power'
    'm.g.Unit'
    'm.g.order.Build'
  ]
  ( Base, Area, Power, Unit, Build )->

    class extends Base
      model_name: 'state'
      
      constructor: ( options, @game, @last = false )->
        super options

      read_data: ->
        @powers = {}
        @areas = {}

        for name, region of regions
          @areas[name] = new Area name, this

        for power_name, power_data of @data.Powers
          power = new Power power_name

          for unit_data in power_data.Units
            unit_info = unit_data.match(/^([AF])(\w+)(?:-(\w+))?$/)
            type = if unit_info[1] == 'A' then 'army' else 'fleet'
            address = unit_info[2].split '_'
            area = @areas[ address[0] ]
            sub_area = address[1] || 'xc'
            dislodged = unit_info[3]

            new Unit power, type, area, sub_area, dislodged

          for area_name in power_data.Areas
            power.add_area @areas[area_name]

          @powers[power_name] = power

        if @data.Embattled
          for area_name in @data.Embattled
            @areas[area_name].embattled = true

        if @type == 'Move'
          for power_name, power_data of @powers
            for unit in power_data.units
              unit.create_order 'Hold'

        if @orders
          whom = if @type == 'Retreat' then 'dislodged' else 'unit'
          for power_name, orders of @orders
            for area_name, order of orders
              if order.type != 'Build'
                unit = @get_area( area_name )[whom]
                unit.create_order order.type, order
              else
                position = area_name.split '_'
                new Build( @areas[position[0]], position[1], order )

        @

      collect_orders: ->
        powers_orders = {}

        for name, power of @powers
          power_orders = {}

          for unit in power.units
            if order = unit.order
              position = if order.type == 'Build' then unit.position() else unit.area.name
              power_orders[ position ] = order.to_json()

          powers_orders[name] = power_orders

        powers_orders

      get_area: ( area )->
        @areas[ area.split('_')[0] ]
