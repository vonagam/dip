###* @jsx React.DOM ###

modulejs.define 'g.v.menu.Participation',
  [ 'vr.Component', 'vr.Button', 'vr.classes', 'icons' ]
  ( Component, Button, classes, icons )->

    React.createClass
      getInitialState: ->
        popup: false
      render: ->
        game = @props.game

        active = game.data.status == 'waiting'

        if active

          button = 
            if game.user_side == null
              Button
                className: 'yellow'
                text: icons.get 'flag', 'participation'
            else
              [
                Button
                  className: 'green'
                  text: icons.get 'flag', 'participation'
                Button
                  href: Routes.game_side_path game.data.id, format: 'json'
                  className: 'red'
                  method: 'delete'
                  remote: true
                  text: icons.get 'flag', 'participation'
              ]

        `<Component className='participation' active={active}>
          {button}
        </Component>`
