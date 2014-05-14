class model.State
  constructor: ( map, data, @type )->
    @powers = {}
    @units = []
    @show_orders = undefined

    for power_name, power_data of data.Powers
      power = new model.Power power_name

      for unit_data in power_data.Units
        unit_info = unit_data.match(/^([AF])(\w+)(?:-(\w+))?$/)
        type = if unit_info[1] == 'A' then 'army' else 'fleet'
        address = unit_info[2].split '_'
        area = map.areas[ address[0] ]
        sub_area = address[1] || 'xc'
        dislodged = unit_info[3]

        unit = new model.Unit power, type, area, sub_area, dislodged

        @units.push unit

      for area_name in power_data.Areas
        power.areas.push map.areas[ area_name ]

      @powers[power_name] = power

    @embattled = []
    if data.Embattled
      for area_name in data.Embattled
        @embattled.push map.areas[ area_name ]

  attach: ->
    power.attach() for power_name, power of @powers
    unit.attach() for unit in @units
    area.embattled(true) for area in @embattled
    return

  detach: ->
    power.detach() for power in @powers
    unit.detach() for unit in @units
    area.embattled(false) for area in @embattled
    return

  toggle_orders: ( bool )->
    return if @show_orders == bool
    unit.toggle_orders bool for unit in @units
    @show_orders = bool
    return

  collect_orders: ( power )->
    orders = {}
    if @type == 'Move'
      for unit in @powers[ power ].units
        orders[ unit.area.name ] = unit.order.to_json()
    if @type == 'Retreat'
      for unit in @powers[ power ].units
        if unit.dislodged
          orders[ unit.area.name ] = unit.order.to_json()
    orders
