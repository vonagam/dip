modulejs.define 'v.g.s.map.order.move.support', ->

  callback = ( name )->
    area = @gstate.get_area name
    supported = area.unit
    supporter = @state.selected.unit

    supporter.create_order 'Support', from: name, to: supported.order.target.name

    unit_selecting = modulejs.require 'v.g.s.map.order.move.unit'
    @changeSelecting unit_selecting
    return

  ( selected )->
    unit = selected.unit
    selectable = []

    for neighbour in unit.neighbours()
      area = @gstate.get_area neighbour

      for from, order of area.targeting
        continue if from == unit.area.name
        selectable.push from

    if selectable.length == 0
      hold_apply = modulejs.require 'v.g.s.map.order.move.hold'
      return hold_apply.call this, selected

    select = support: { selectable: selectable, callback: callback.bind(@) }

    step: 'maneuver support'
    selected: { unit: unit }
    select: select
