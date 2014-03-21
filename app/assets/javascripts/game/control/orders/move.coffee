g.orders.move =
  select: g.select( 'destination', ()-> g.orders.move.after_select() )

  turn: (on_off)->
    g.container.toggleClass 'order_move', on_off == 'on'

    @show_possible_moves if on_off == 'on' then 'destination' else undefined

    @select.turn on_off

  show_possible_moves: (destination_undefined)->
    for possibility in g.orders.selected_force.data('neighbours')
      g.map.find('#'+possibility).dttr 'selectable', destination_undefined

  after_select: ()->
    g.orders.move.turn 'off'
    g.orders.select_turn 'on'
