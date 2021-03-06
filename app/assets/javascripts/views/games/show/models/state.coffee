class g.model.State
  constructor: ( @raw )->
    @last = false

  read_data: ->
    @powers = {}
    @areas = {}

    for name, region of regions
      @areas[name] = new g.model.Area name, this

    for power_name, power_data of @raw.data.Powers
      power = new g.model.Power power_name

      for unit_data in power_data.Units
        unit_info = unit_data.match(/^([AF])(\w+)(?:-(\w+))?$/)
        type = if unit_info[1] == 'A' then 'army' else 'fleet'
        address = unit_info[2].split '_'
        area = @areas[ address[0] ]
        sub_area = address[1] || 'xc'
        dislodged = unit_info[3]

        new g.model.Unit power, type, area, sub_area, dislodged

      for area_name in power_data.Areas
        power.add_area @areas[area_name]

      @powers[power_name] = power

    if @raw.data.Embattled
      for area_name in @raw.data.Embattled
        @areas[area_name].embattled = true

    if @type() == 'Move'
      for power_name, power_data of @powers
        for unit in power_data.units
          g.set_order unit, 'Hold'

    if @raw.orders
      whom = if @type() == 'Retreat' then 'dislodged' else 'unit'
      for power_name, orders of @raw.orders
        for area_name, order of orders
          if order.type != 'Build'
            unit = @get_area( area_name )[whom]
            g.set_order unit, order.type, order
          else
            position = area_name.split '_'
            new g.model.Order.Build( @areas[position[0]], position[1], order )

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

  type: ->
    @raw.type
