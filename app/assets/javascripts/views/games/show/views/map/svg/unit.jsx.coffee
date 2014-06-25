###* @jsx React.DOM ###

g.view.Unit = React.createClass
  render: ->
    unit = @props.model
    className = vr.classes 'unit', unit.type, dislodged: unit.dislodged
    power = unit.power.name
    points = if unit.type == 'army' then '-4,-4 -4,4 4,4 4,-4' else '-6,-2 0,5 6,-2'

    coords = g.unit_coords @props.coords, unit

    transform = g.translate coords

    `<polygon 
      className={className}
      data-power={power}
      points={points} 
      transform={transform} 
    />`
