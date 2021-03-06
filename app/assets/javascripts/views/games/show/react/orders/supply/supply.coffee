set_build = ( area, possible )->
  new g.model.Order.Build area, possible.sub, { unit: possible.type }
  return

build_callback = ( name )->
  area = @state.get_area name
  unit = area.unit
  possible = area.possible_builds()

  if !unit
    set_build area, possible[0]
  else
    unit.order.remove()

    index = possible.indexOf possible.filter( (p)->
      p.sub == unit.sub_area && p.type == unit.type
    )[0]

    set_build area, possible[ index + 1 ] if index + 1 < possible.length

  @changeSelecting Orders.Supply.supply
  return


disband_callback = ( name )->
  unit = @state.get_area( name ).unit

  if unit.order
    unit.set_order null
  else
    g.set_order @unit, 'Disband'

  @changeSelecting Orders.Supply.supply
  return

Orders.Supply.supply = ->
  select =
    build: { selectable: [], callback: build_callback.bind(@) }
    disband: { selectable: [], callback: disband_callback.bind(@) }

  for name, power of @state.powers
    all_units = power.units
    real_units = all_units.filter (unit)-> !unit.order
    supplies = power.supplies()

    surplus = supplies.length - real_units.length

    continue if surplus == 0

    if surplus > 0
      for supply in supplies
        continue if supply.unit && !supply.unit.order

        if supply.unit || real_units.length < supplies.length
          select.build.selectable.push supply.name

    else
      for unit in units
        if unit.order || real_units.length > supplies.length
          select.disband.selectable.push unit.area.name

  step: 'supply'
  selected: null
  select: select
