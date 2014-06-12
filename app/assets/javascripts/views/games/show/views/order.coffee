class g.view.Order extends g.view.Base
  constructor: ( game )->
    super game, 'order'

    @button = @find '.send'

    @button.clicked ()=>
      state = @game.state
      power = @game.user_side.power
      orders = state.collect_orders power

      @button.ajax 'post', @button.data('url'), { order: { data: JSON.stringify(orders) } }, (order)=>
        if state.last
          state.raw.orders = {}
          state.raw.orders[ power ] = order.data

          if state.attached
            state.reset()
            @update false

        return
      return


  is_active: ->
    @game.status == 'started' && 
    @game.state.last &&
    @game.user_side &&
    @game.user_side.orderable


  update: ( game_updated )->
    return if game_updated

    @update_status()

    if @game.status == 'started' && @game.state.last
      g.game_phase[@game.state.type()].turn true
    else
      g.order_index.turn false

    if @turned
      @button.removeClass 'green yellow'
      color = if @game.state.raw.orders then 'green' else 'yellow'
      @button.addClass color

    return
