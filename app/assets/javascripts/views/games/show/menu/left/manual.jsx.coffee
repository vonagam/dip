###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Manual',
  [ 'v.g.s.menu.buttonComponent' ]
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
          className: 'yellow'
          method: 'post'
          remote: true
          text: `<i className='fa fa-play' title='progress' />`
      )
