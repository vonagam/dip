###* @jsx React.DOM ###

modulejs.define 'g.v.map.svg.Abbr', ->

  React.createClass
    render: ->
      name = @props.name

      abbr_text = 
        if @props.type == 'water' 
          name.toUpperCase()
        else
          name.charAt(0).toUpperCase() + name.slice(1)

      `<text className='abbr' x={this.props.coords.x} y={this.props.coords.y}>
        {abbr_text}
      </text>`
