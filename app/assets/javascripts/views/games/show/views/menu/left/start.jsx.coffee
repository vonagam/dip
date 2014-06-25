###* @jsx React.DOM ###

modulejs.define 'g.v.menu.Start',
  [ 'g.v.menu.buttonComponent' ]
  ( buttonComponent )->

    React.createClass
      render: buttonComponent(
          'start'
          ( game )-> game.user_side?.creator && game.data.status == 'waiting'
          ( game )->
            href: Routes.progress_game_path game.data.id, format: 'json'
            className: 'green'
            method: 'post'
            remote: true
            text: 'start'
        )
