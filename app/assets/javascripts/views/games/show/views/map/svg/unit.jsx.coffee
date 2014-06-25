###* @jsx React.DOM ###

modulejs.define 'g.v.map.svg.Unit',
  [ 'vr.classes', 'g.v.map.svg.unit_coords' ]
  ( classes, c )->

    React.createClass
      render: ->
        unit = @props.model
        className = classes 'unit', unit.type, dislodged: unit.dislodged
        power = unit.power.name
        points = if unit.type == 'army' then '-4,-4 -4,4 4,4 4,-4' else '-6,-2 0,5 6,-2'

        coords = c.unit_coords @props.coords, unit

        transform = c.translate coords

        `<polygon 
          className={className}
          data-power={power}
          points={points} 
          transform={transform} 
        />`
