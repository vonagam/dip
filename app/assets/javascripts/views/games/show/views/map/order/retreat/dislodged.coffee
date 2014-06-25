modulejs.define 'g.v.map.order.retreat.dislodged',
  ->

    callback = ( name )->
      area = @gstate.get_area name
      dislodged = area.dislodged

      retreat_selecting = modulejs.require 'g.v.map.order.retreat.retreat'
      @changeSelecting retreat_selecting, dislodged: dislodged
      return

    ->
      selectable = []
      for name, power of @gstate.powers
        for unit in power.units
          selectable.push unit.area.name if unit.status == 'dislodged'

      step: 'dislodged'
      selected: null
      select: dislodged: { selectable: selectable, callback: callback.bind(@) }
