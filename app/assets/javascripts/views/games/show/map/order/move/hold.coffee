modulejs.define 'v.g.s.map.order.move.hold',
  ['v.g.s.map.order.move.unit']
  ( unit_selecting )->

    ( selected )->
      selected.unit.create_order 'Hold'
      unit_selecting.apply this
