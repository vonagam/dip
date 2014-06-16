class g.view.Order extends g.view.Base
  constructor: ( game )->
    super game, 'order'

    @button = @find '.send'

    @button.clicked ()=>
      state = @game.state
      orders = state.collect_orders()

      @button.ajax 'post', @button.data('url'), { order: { data: JSON.stringify(orders) } }, (order)=>
        if state.last
          state.raw.orders = order.data

          if state.attached
            state.reset()
            @update false

        return
      return


  is_active: ->
    @game.status == 'going' && 
    @game.state.last &&
    @game.user_side &&
    @game.user_side.orderable


  update: ( game_updated )->
    return if game_updated

    @update_status()

    if @game.status == 'going' && @game.state.last
      g.game_phase[@game.state.type()].turn true

    if @turned
      @button.removeClass 'green yellow'
      color = if @game.state.raw.orders then 'green' else 'yellow'
      @button.addClass color

    return
