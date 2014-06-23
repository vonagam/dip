Orders.Move.hold = ( unit )->
  g.set_order unit, 'Hold'
  Order.Move.unit.apply this
