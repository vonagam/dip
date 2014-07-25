###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Start',
  [ 'v.g.s.menu.buttonComponent' ]
  ( buttonComponent )->

    React.createClass
      render: buttonComponent(
          'start'
          ( game )-> game.user_side?.creator && game.data.status == 'waiting'
          ( game )->
            href: Routes.progress_game_path game.data.id, format: 'json'
            className: 'yellow'
            method: 'post'
            remote: true
            text: `<i className='fa fa-flag-checkered' title='start' />`
        )
