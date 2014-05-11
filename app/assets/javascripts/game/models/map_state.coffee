class klass.MapState
  constructor: ( map, data )->
    @powers = {}
    @units = []
    @show_orders = undefined

    for power_name, power_data of data.Powers
      power = new klass.Power power_name

      for unit_data in power_data.Units
        unit_info = unit_data.match(/^([AF])(\w+)$/)
        type = if unit_info[1] == 'A' then 'army' else 'fleet'
        address = unit_info[2].split '_'
        area = map.areas[ address[0] ]
        sub_area = address[1] || 'xc'

        unit = new klass.Unit power, type, area, sub_area

        @units.push unit

      for area_name in power_data.Areas
        power.areas.push map.areas[ area_name ]

      @powers[power_name] = power

  attach: ->
    power.attach() for power_name, power of @powers
    unit.attach() for unit in @units
    return

  detach: ->
    power.detach() for power in @powers
    unit.detach() for unit in @units
    return

  toggle_orders: ( bool )->
    return if @show_orders == bool
    unit.toggle_orders bool for unit in @units
    @show_orders = bool
    return

