###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Delete',
  [ 'cancan', 'v.g.s.menu.buttonComponent', 'icons' ]
  ( can, buttonComponent, icons )->
    
    React.createClass
      render: buttonComponent(
          'delete'
          ( game )-> can 'destroy', game
          ( game )->
            href: Routes.game_path game.id, format: 'json'
            className: 'red'
            method: 'delete'
            remote: true
            confirm: 'Are you sure?'
            text: icons.get 'trash-o', 'delete'
        )
