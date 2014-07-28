###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Start',
  [ 'cancan', 'v.g.s.menu.buttonComponent' ]
  ( can, buttonComponent )->

    React.createClass
      render: buttonComponent(
          'start'
          ( game )-> can 'start', game
          ( game )->
            href: Routes.start_game_path game.id, format: 'json'
            className: 'yellow'
            method: 'post'
            remote: true
            text: `<i className='fa fa-flag-checkered' title='start' />`
        )
