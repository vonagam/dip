###* @jsx React.DOM ###

g.view.LinkToRoot = React.createClass
  render: g.view.renderButtonComponent(
    'root'
    ( game )-> true
    ( game )-> className: 'grey', href: '/', text: 'root'
  )
