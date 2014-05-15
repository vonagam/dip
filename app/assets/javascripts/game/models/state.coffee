class model.State
  constructor: ( data, @type )->
    @powers = {}
    @units = []
    @areas = {}

    for name, region of regions
      @areas[name] = new model.Area name, this

    for power_name, power_data of data.Powers
      power = new model.Power power_name

      for unit_data in power_data.Units
        unit_info = unit_data.match(/^([AF])(\w+)(?:-(\w+))?$/)
        type = if unit_info[1] == 'A' then 'army' else 'fleet'
        address = unit_info[2].split '_'
        area = @areas[ address[0] ]
        sub_area = address[1] || 'xc'
        dislodged = unit_info[3]

        unit = new model.Unit power, type, area, sub_area, dislodged

        @units.push unit

      for area_name in power_data.Areas
        power.add_area @areas[area_name]

      @powers[power_name] = power

    if data.Embattled
      for area_name in data.Embattled
        @areas[area_name].embattled = true

  attach: ->
    area.attach() for name, area of @areas
    unit.attach() for unit in @units
    return

  detach: ->
    area.detach() for name, area of @areas
    unit.detach() for unit in @units
    return

  collect_orders: ( power )->
    orders = {}
    if @type == 'Move'
      for unit in @powers[ power ].units
        orders[ unit.area.name ] = unit.order.to_json() if unit.order.type != 'Hold'
    if @type == 'Retreat'
      for unit in @powers[ power ].units
        if unit.dislodged
          orders[ unit.area.name ] = unit.order.to_json()
    orders

  get_area: ( area )->
    @areas[ area.split('_')[0] ]
