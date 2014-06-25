modulejs.define 'g.v.map.order.retreat.retreat',
  ->

    callback = ( name )->
      target = @gstate.get_area name
      unit = @state.selected.dislodged

      if target == unit.area
        unit.set_order null
      else
        unit.create_order 'Retreat', to: name

      dislodged_selecting = modulejs.require 'g.v.map.order.retreat.dislodged'
      @changeSelecting unit_selecting
      return

    ( selected )->
      unit = selected.dislodged

      selectable = unit.neighbours().filter ( possibility )=>
        area = @gstate.get_area possibility
        !( area.embattled || area.unit || area.name == unit.dislodged )

      select = retreat: 
        selectable: selectable.concat unit.area.name
        callback: callback.bind(@)

      step: 'maneuver retreat'
      selected: { dislodged: unit }
      select: select
