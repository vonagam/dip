g.orders =
  current_state: undefined
  order_type: 'move'
  selected_force: undefined
  forces: undefined
  select: g.select( 'order', ()-> g.orders.force_selected() )


  turn: (on_off)->
    g.container.toggleClass 'state_orders', on_off == 'on'

    if on_off == 'on'
      @forces = g.map.find('.force')
      @select_turn 'on'

    else
      if @current_state
        @current_state.turn 'off'
      else
        @select_turn 'off'

      if @selected_force
        @selected_force.parent().dttr('selected', false)
        @selected_force = undefined

    return this


  select_turn: (on_off)->
    g.container.toggleClass 'force_select', on_off == 'on'

    @forces.parent().dttr 'selectable', if on_off == 'on' then 'order' else undefined

    if on_off == 'on'
      @current_state = undefined
      @selected_force = undefined

    @select.turn on_off


  force_selected: ()->
    @selected_force = @select.selected.dttr('selected', true).find('.force')
    @select_turn 'off'
    @current_state = @[@order_type].turn 'on'


  change_order_type: (type)->
    if g.state != g.orders || !@current_state
      @order_type = type
      return

    @current_state.turn 'off'
    @order_type = type
    @current_state = @[@order_type].turn 'on'
