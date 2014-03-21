class g.OrderIndex extends klass.StateListLooped

  constructor: ()->
    super
    @toggls.game = target: '#game_container', class: 'order_index'


g.order_index = new g.OrderIndex

log g.order_index.toggls


g.order_force_select = new g.SelectingState
  selecting: ()-> $('#diplomacy_map .force').parent()
  marking: '[order_force_select]'
  container: '#diplomacy_map'
  
log g.order_force_select.toggls

#g.order_index.add [g.order_force_select]
