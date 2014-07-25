###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Player',
  [ 'vr.Component', 'vr.classes' ]
  ( Component, classes )->

    React.createClass
      render: ->
        name = @props.user?.login

        if name
          login = `<div className='login'>{name}</div>`

          if side = @props.game.user_side?.get_name()
            power = `<div className='power'>{side}</div>`

        className = classes 'player', two_line: power != null

        `<Component className={className} active={name}>
          {login}
          {power}
        </Component>`
