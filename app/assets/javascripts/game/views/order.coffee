class view.Order
  constructor: ( @game )->
    @view = g.page.find '.order.j_component'
    @button = @view.find '.button'

    @button.clicked ()=>
      orders = @game.state.collect_orders @game.user_side.power
      @button.ajax 'post', @button.data('url'), { order: { data: JSON.stringify(orders) } }, (game_data)=>
        @game.update game_data
        return
      return

  update: ->
    g.order_index.turn false


    allow_experiment = @game.status == 'started' && @game.state.last

    g.game_phase[@game.state.type()].turn true if allow_experiment


    allow_order = allow_experiment && @game.user_side && @game.user_side.orderable

    @view.toggle allow_order

    if allow_order
      @button.removeClass 'green yellow'
      color = if @game.state.raw.orders then 'green' else 'yellow'
      @button.addClass color

    return
