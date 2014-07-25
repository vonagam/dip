###* @jsx React.DOM ###

modulejs.define 'v.g.s.map.svg.Embattled',
  [ 'v.g.s.map.svg.unit_coords' ]
  ( c )->

    React.createClass
      render: ->
        `<polygon
          className='embattled'
          points='0,-5 1.5,-2 4.8,-1.5 2.4,0.8 3,4 0,2.5 -3,4 -2.4,0.8 -4.8,-1.5 -1.5,-2'
          transform={ c.translate( this.props.coords ) }
        />`
