callback = ( name )->
  area = @gstate.get_area name
  unit = area.unit

  @changeSelecting Orders.Retreat.retreat, unit
  return

Orders.Retreat.unit = ->
  selectable = []
  for name, power of @gstate.powers
    for unit in power.units
      selectable.push unit.area.name if unit.status == 'dislodged'

  step: 'unit'
  selected: null
  select: unit: { selectable: selectable, callback: callback.bind(@) }
