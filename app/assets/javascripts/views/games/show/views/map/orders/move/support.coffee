callback = ( name )->
  area = @gstate.get_area name
  supported = area.unit
  supporter = @state.selected.unit

  g.set_order supporter, 'Support', from: name, to: supported.order.target.name

  @changeSelecting Orders.Move.unit
  return

Orders.Move.support = ( selected )->
  unit = selected.unit
  selectable = []

  for neighbour in unit.neighbours()
    area = @gstate.get_area neighbour

    for from, order of area.targeting
      continue if from == unit.area.name
      selectable.push from

  if selectable.length == 0
    return Order.Move.hold.call this, unit

  select = support: { selectable: selectable, callback: callback.bind(@) }

  step: 'maneuver support'
  selected: { unit: unit }
  select: select
