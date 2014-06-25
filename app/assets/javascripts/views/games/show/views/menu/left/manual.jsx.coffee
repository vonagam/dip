###* @jsx React.DOM ###

modulejs.define 'g.v.menu.Manual',
  [ 'g.v.menu.buttonComponent' ]
  ( buttonComponent )->

    React.createClass
      render: buttonComponent(
        'manual'
        ( game )-> 
          game.user_side?.creator &&
          game.data.time_mode == 'manual' && 
          game.data.status == 'going'
        ( game )->
          href: Routes.progress_game_path game.data.id, format: 'json'
          className: 'red'
          method: 'post'
          remote: true
          text: 'progress'
      )
