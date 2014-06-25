Orders.Move.hold = ( selected )->
  g.set_order selected.unit, 'Hold'
  Orders.Move.unit.apply this
