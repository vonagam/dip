callback = ( name )->
  area = @gstate.get_area name
  unit = area.unit

  @changeSelecting Orders.Move.move, unit: unit
  return

Orders.Move.unit = ->
  selectable = [] 

  for name, power of @gstate.powers
    for unit in power.units
      selectable.push unit.area.name

  step: 'unit'
  selected: null
  select: unit: { selectable: selectable, callback: callback.bind(@) }
