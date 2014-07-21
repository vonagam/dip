###* @jsx React.DOM ###

modulejs.define 'g.v.menu.SendOrders',
  [ 'g.v.menu.buttonComponent', 'vr.stopEvent' ]
  ( buttonComponent, stopEvent )->

    React.createClass
      onMouseDown: (e)->
        orders = JSON.stringify @props.game.state.collect_orders()

        $(@getDOMNode()).ajax 'post',
          Routes.game_order_path @props.game.data.id, format: 'json'
          order: { data: orders }
          ( order )=>
            state = @props.game.state

            if state.last
              state.raw.orders = order.data
              @props.page.forceUpdate()

            return

        return stopEvent e
      render: buttonComponent(
        'order'
        ( game )-> 
          game.data.status == 'going' && 
          game.state.last &&
          game.user_side?.orderable
        ( game )->
          className: 'send ' + if game.state.raw.orders then 'green' else 'yellow'
          text: `<i className='fa fa-pencil' title='send orders' />`
          onMouseDown: @onMouseDown
      )
