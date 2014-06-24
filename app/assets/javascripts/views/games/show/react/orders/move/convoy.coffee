continue_callback = ( name )->
  target = @gstate.get_area name
  army = @state.selected.army
  fleets = @state.selected.fleets

  @changeSelecting Orders.Move.convoy, army, [target.unit].concat fleets 
  return

end_callback = ( name )->
  target = @gstate.get_area name
  army = @state.selected.unit
  fleets = @state.selected.fleets

  g.set_order army, 'Move', to: name

  for fleet in fleets
    g.set_order fleet, 'Convoy', from: army.area.name, to: name

  @changeSelecting Orders.Move.unit
  return

Orders.Move.convoy = ( army, fleets )->
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
  
  step: 'convoy'
  selected: { unit: army, fleets: fleets }
  select: select
