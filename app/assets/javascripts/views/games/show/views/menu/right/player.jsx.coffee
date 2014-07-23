###* @jsx React.DOM ###

modulejs.define 'g.v.menu.Player',
  [ 'vr.Component', 'vr.classes' ]
  ( Component, classes )->

    React.createClass
      render: ->
        game = @props.game
        name = game.data.access.user

        active = name != undefined

        if active
          login = `<div className='login'>{name}</div>`

          if game.user_side
            power = `<div className='power'>{game.user_side.name || 'Random'}</div>`

        className = classes 'player', two_line: power != null

        `<Component className={className} active={active}>
          {login}
          {power}
        </Component>`
