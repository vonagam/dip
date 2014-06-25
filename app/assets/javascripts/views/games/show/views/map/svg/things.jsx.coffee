###* @jsx React.DOM ###

g.view.Center = React.createClass
  render: ->
    `<circle 
      className='center' 
      r='3'
      cx={this.props.coords.x}
      cy={this.props.coords.y}
    />`

g.view.Abbr = React.createClass
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

g.view.Embattled = React.createClass
  render: ->
    `<polygon
      className='embattled'
      points='0,-5 1.5,-2 4.8,-1.5 2.4,0.8 3,4 0,2.5 -3,4 -2.4,0.8 -4.8,-1.5 -1.5,-2'
      transform={ g.translate( this.props.coords ) }
    />`
