###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.LinkToRoot',
  [ 'v.g.s.menu.buttonComponent' ]
  ( buttonComponent )->

    React.createClass
      render: buttonComponent(
        'root'
        ( game )-> true
        ( game )-> 
          className: 'grey'
          href: '/'
          text: `<i className='fa fa-home' title='root' />`
      )
