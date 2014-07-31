###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.SendOrders',
  [ 'cancan', 'v.g.s.menu.buttonComponent', 'vr.stopEvent' ]
  ( can, buttonComponent, stopEvent )->

    React.createClass
      onMouseDown: (e)->
        orders = JSON.stringify @props.game.state.collect_orders()

        $(@getDOMNode()).ajax 'post',
          Routes.game_order_path @props.game.id, format: 'json'
          order: { data: orders }
          ( order )=>
            @props.page.updateGame orders: $set: order.data
            return

        return stopEvent e
      render: buttonComponent(
        'order'
        ( game )-> can 'send order', game
        ( game )->
          className: 'send ' + if game.state.orders then 'yellow' else 'green'
          text: `<i className='fa fa-pencil' title='send orders' />`
          onMouseDown: @onMouseDown
      )
