move_callback = ( name )->
  target = @gstate.get_area name
  unit = @state.selected.unit

  if target == unit.area
    g.set_order unit, 'Hold'
  else
    g.set_order unit, 'Move', to: name

  @changeSelecting Orders.Move.unit
  return

convoy_callback = ( name )->
  target = @gstate.get_area name
  fleet = target.unit
  unit = @state.selected.unit
  @changeSelecting Orders.Move.convoy, unit: unit, fleets: [fleet]
  return

Orders.Move.move = ( selected )->
  unit = selected.unit
  select = {}

  select.move = 
    selectable: unit.neighbours().concat unit.area.name
    callback: move_callback.bind(@)

  if unit.type == 'army'
    selectable = unit.area.neighbours().filter (area_name)=>
      area = @gstate.get_area area_name
      area.type() == 'water' && area.unit

    select.convoy = selectable: selectable, callback: convoy_callback.bind(@)

  step: 'maneuver move'
  selected: { unit: unit }
  select: select
