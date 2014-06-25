###* @jsx React.DOM ###

g.view.Rollback = React.createClass
  componentDidMount: ()->
    node = $ @getDOMNode()
    node.on 'ajax:success', ( e, data )=>
      page = @props.page
      page.setState page.state_from_data data
      return
    return
  render: g.view.renderButtonComponent(
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
        text: 'rollback'
    )
