###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Rollback',
  [ 'cancan', 'v.g.s.menu.buttonComponent' ]
  ( can, buttonComponent )->

    React.createClass
      render: buttonComponent(
          'rollback'
          ( game )-> can 'destroy state', game
          ( game )->
            href: Routes.rollback_game_path game.id, format: 'json'
            className: 'red'
            method: 'post'
            remote: true
            text: `<i className='fa fa-undo' title='rollback' />`
        )
