modulejs.define 'g.v.map.order.move.hold',
  ['g.v.map.order.move.unit']
  ( unit_selecting )->

    ( selected )->
      selected.unit.create_order 'Hold'
      unit_selecting.apply this
