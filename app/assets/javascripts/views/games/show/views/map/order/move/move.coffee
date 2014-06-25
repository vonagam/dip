modulejs.define 'g.v.map.order.move.move', ->

  move_callback = ( name )->
    target = @gstate.get_area name
    unit = @state.selected.unit

    if target == unit.area
      unit.create_order 'Hold'
    else
      unit.create_order 'Move', to: name

    unit_selecting = modulejs.require 'g.v.map.order.move.unit'
    @changeSelecting unit_selecting
    return

  convoy_callback = ( name )->
    target = @gstate.get_area name
    fleet = target.unit
    unit = @state.selected.unit

    convoy_selecting = modulejs.require 'g.v.map.order.move.convoy'
    @changeSelecting convoy_selecting, unit: unit, fleets: [fleet]
    return

  ( selected )->
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
