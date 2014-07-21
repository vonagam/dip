###* @jsx React.DOM ###

modulejs.define 'g.v.menu.Rollback',
  [ 'g.v.menu.buttonComponent' ]
  ( buttonComponent )->

    React.createClass
      componentDidMount: ()->
        node = $ @getDOMNode()
        node.on 'ajax:success', ( e, data )=>
          page = @props.page
          page.setState page.state_from_data data
          return
        return
      render: buttonComponent(
          'rollback'
          ( game )->
            game.user_side?.creator &&
            game.data.status == 'going' && 
            game.states.length > 1 && 
            game.data.sides.length == 1
          ( game )->
            href: Routes.rollback_game_path game.data.id, format: 'json'
            className: 'red'
            method: 'post'
            remote: true
            text: `<i className='fa fa-undo' title='rollback' />`
        )
