###* @jsx React.DOM ###


region = React.createClass
  render: ->
    name = this.props.name

    polygons = []

    for polygon, i in this.props.data.polygons
      options = key: i, className: polygon.type
      
      options.id = "#{name}_#{polygon.part}" if polygon.part

      if polygon.d
        options.d = polygon.d
        type = 'path'
      else
        options.points = polygon.points
        type = if polygon.part then 'polyline' else 'polygon'

      polygons.push React.DOM[type]( options )

    `<g id={name}>{polygons}</g>`


vr.Svg = React.createClass
  render: ->
    regions = []
    for name, data of this.props.data.regions
      regions.push `<region key={name} name={name} data={data} />`

    `<svg 
      id='diplomacy_map' 
      viewBox='0 0 610 560'
    >
      {regions}
    </svg>`
