class model.State
  constructor: ( @raw, @game )->
    @attached = false
    @last = false

  reset: ->
    @detach()
    @attach()

  read_data: ->
    @powers = {}
    @areas = {}

    for name, region of regions
      @areas[name] = new model.Area name, this

    for power_name, power_data of @raw.data.Powers
      power = new model.Power power_name

      for unit_data in power_data.Units
        unit_info = unit_data.match(/^([AF])(\w+)(?:-(\w+))?$/)
        type = if unit_info[1] == 'A' then 'army' else 'fleet'
        address = unit_info[2].split '_'
        area = @areas[ address[0] ]
        sub_area = address[1] || 'xc'
        dislodged = unit_info[3]

        new model.Unit power, type, area, sub_area, dislodged

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
            new model.Order.Build( @areas[position[0]], position[1], order )

  attach: ->
    @read_data()

    area.attach() for name, area of @areas
    power.attach() for name, power of @powers

    @attached = true
    return

  detach: ->
    area.detach() for name, area of @areas
    power.detach() for name, power of @powers

    @attached = false
    return

  collect_orders: ( power )->
    orders = {}

    for unit in @powers[ power ].units
      if unit.order
        position = if @type() == 'Supply' then unit.position() else unit.area.name
        orders[ position ] = unit.order.to_json()

    orders

  get_area: ( area )->
    @areas[ area.split('_')[0] ]

  type: ->
    @raw.type
