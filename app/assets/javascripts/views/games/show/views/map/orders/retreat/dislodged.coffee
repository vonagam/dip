callback = ( name )->
  area = @gstate.get_area name
  dislodged = area.dislodged

  @changeSelecting Orders.Retreat.retreat, dislodged: dislodged
  return

Orders.Retreat.dislodged = ->
  selectable = []
  for name, power of @gstate.powers
    for unit in power.units
      selectable.push unit.area.name if unit.status == 'dislodged'

  step: 'dislodged'
  selected: null
  select: dislodged: { selectable: selectable, callback: callback.bind(@) }
