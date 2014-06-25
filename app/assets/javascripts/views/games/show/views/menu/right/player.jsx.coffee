###* @jsx React.DOM ###

g.view.Player = React.createClass
  render: ->
    Component = vr.Component

    game = @props.game
    name = game.data.login

    active = name != undefined

    if active
      login = `<div className='login'>{name}</div>`

      if game.user_side
        power = `<div className='power'>{game.user_side.name || 'Random'}</div>`

    className = vr.classes 'player', two_line: power != null

    `<Component className={className} active={active}>
      {login}
      {power}
    </Component>`
