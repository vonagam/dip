###* @jsx React.DOM ###

modulejs.define 'g.v.menu.LinkToRoot',
  [ 'g.v.menu.buttonComponent' ]
  ( buttonComponent )->

    React.createClass
      render: buttonComponent(
        'root'
        ( game )-> true
        ( game )-> className: 'grey', href: '/', text: 'root'
      )
