move_callback = ( name )->
  target = @gstate.get_area name
  unit = @gstate.selected.unit

  if target == unit.area
    g.set_order unit, 'Hold'
  else
    g.set_order unit, 'Move', to: name

  @changeSelecting Orders.Move.unit
  return

convoy_callback = ( name )->
  target = @gstate.get_area name
  fleet = target.unit
  unit = @gstate.selected.unit
  @changeSelecting Orders.Move.convoy, unit, [fleet]
  return

Orders.Move.move = ( unit )->
  select = {}

  select.move = 
    selectable: unit.neighbours().concat unit.area.name
    callback: move_callback.bind(@)

  if unit.type == 'army'
    selectable = unit.area.neighbours().filter (area_name)=>
      area = @gstate.get_area area_name
      nei_area.type() == 'water' && nei_area.unit

    select.convoy = selectable: selectable, callback: convoy_callback.bind(@)

  step: 'move'
  selected: { unit: unit }
  select: select
