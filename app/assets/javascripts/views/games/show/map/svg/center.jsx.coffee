###* @jsx React.DOM ###

modulejs.define 'v.g.s.map.svg.Center', ->

  React.createClass
    render: ->
      `<circle 
        className='center' 
        r='3'
        cx={this.props.coords.x}
        cy={this.props.coords.y}
      />`
