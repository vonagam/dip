modulejs.define 'g.v.map.order.move.unit', ->

  callback = ( name )->
    area = @gstate.get_area name
    unit = area.unit

    move_selecting = modulejs.require 'g.v.map.order.move.move'
    @changeSelecting move_selecting, unit: unit
    return

  ->
    selectable = [] 

    for name, power of @gstate.powers
      for unit in power.units
        selectable.push unit.area.name

    step: 'unit'
    selected: null
    select: unit: { selectable: selectable, callback: callback.bind(@) }
