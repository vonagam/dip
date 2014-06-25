###* @jsx React.DOM ###

modulejs.define 'g.v.menu.Delete',
  [ 'g.v.menu.buttonComponent' ]
  ( buttonComponent )->
    
    React.createClass
      render: buttonComponent(
          'delete'
          ( game )->
            game.user_side?.creator &&
            ( 
              switch game.data.status
                when 'waiting' then true
                when 'going'
                  game.data.time_mode == 'manual' || 
                  game.states[ game.states.length - 1 ].raw.end_at == null
            )
          ( game )->
            href: Routes.game_path game.data.id, format: 'json'
            className: 'red'
            method: 'delete'
            remote: true
            confirm: 'Are you sure?'
            text: 'delete'
        )
