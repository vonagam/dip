###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Manual',
  [ 'cancan', 'v.g.s.menu.buttonComponent' ]
  ( can, buttonComponent )->

    React.createClass
      render: buttonComponent(
        'manual'
        ( game )-> can 'progress', game
        ( game )->
          href: Routes.progress_game_path game.id, format: 'json'
          className: 'yellow'
          method: 'post'
          remote: true
          text: `<i className='fa fa-play' title='progress' />`
      )
