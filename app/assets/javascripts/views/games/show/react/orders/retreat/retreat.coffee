callback = ( name )->
  target = @gstate.get_area name
  unit = @state.selected.unit

  if target == unit.area
    unit.set_order null
  else
    g.set_order unit, 'Retreat', to: name

  @changeSelecting Orders.Retreat.unit
  return

Orders.Retreat.retreat = ( unit )->
  select = {}

  selectable = unit.neighbours().filter ( possibility )->
    area = @gstate.get_area possibility
    !( area.embattled || area.unit || area.name == unit.dislodged )

  select.retreat = 
    selectable: selectable.concat unit.area.name
    callback: callback.bind(@)

  step: 'retreat'
  selected: { unit: unit }
  select: select
