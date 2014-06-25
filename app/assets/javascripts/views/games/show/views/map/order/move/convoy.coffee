modulejs.define 'g.v.map.order.move.convoy', ->

  continue_callback = ( name )->
    target = @gstate.get_area name
    army = @state.selected.army
    fleets = @state.selected.fleets

    @changeSelecting convoy_selecting, unit: army, fleets: [target.unit].concat fleets 
    return

  end_callback = ( name )->
    target = @gstate.get_area name
    army = @state.selected.unit
    fleets = @state.selected.fleets

    army.create_order 'Move', to: name

    for fleet in fleets
      fleet.create_order 'Convoy', from: army.area.name, to: name

    unit_selecting = modulejs.require 'g.v.map.order.move.unit'
    @changeSelecting unit_selecting
    return

  convoy_selecting = ( selected )->
    army = selected.unit
    fleets = selected.fleets
    continues = []
    ends = []

    units_areas = fleets.concat( army ).map (unit)-> unit.area.name

    for name in fleets[0].area.neighbours()
      area = @gstate.get_area name

      if ( area.type() != 'water' || area.unit ) && units_areas.indexOf( name ) == -1
        ( if area.type() == 'water' then continues else ends ).push area.name

    select = 
      continues: { selectable: continues, callback: continue_callback.bind(@) }
      ends: { selectable: ends, callback: end_callback.bind(@) }
    
    step: 'maneuver convoy'
    selected: { unit: army, fleets: fleets }
    select: select

  convoy_selecting
