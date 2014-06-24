callback = ( name )->
  area = @gstate.get_area name
  supported = area.unit
  supporter = @gstate.selected.unit

  g.set_order supporter, 'Support', from: name, to: supported.order.target.name

  @changeSelecting Orders.Move.unit
  return

Orders.Move.support = ( unit )->
  selectable = []

  for neighbour in unit.neighbours()
    area = state.get_area neighbour

    for from, order of area.targeting
      continue if from == unit.area.name
      selectable.push area.name

  if selectable.length == 0
    return Order.Move.hold.call this, unit

  select = support: { selectable: selectable, callback: callback.bind(@) }

  step: 'support'
  selected: { unit: unit }
  select: select
