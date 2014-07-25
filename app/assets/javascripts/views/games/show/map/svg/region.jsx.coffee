###* @jsx React.DOM ###

modulejs.define 'v.g.s.map.svg.Region', 
  [ 
    'v.g.s.map.svg.Polygon'
    'v.g.s.map.svg.Center'
    'v.g.s.map.svg.Abbr'
    'v.g.s.map.svg.Unit'
    'v.g.s.map.svg.Embattled'
    'v.g.s.map.order.isSelectable' 
  ]
  ( 
    Polygon
    Center
    Abbr
    Unit
    Embattled
    isSelectable 
  )->

    React.createClass
      render: ->
        name = @props.name
        model = @props.model
        region = model.region()
        coords = @props.coords[name]
        control = @props.control
        power = model.power?.name

        polygons = []
        coords.polygons.forEach (polygon, index)->
          polygons.push `<Polygon key={index} region={name} polygon={polygon} control={control} />`
        
        #TODO wait fix in gem
        #title = `<title>{region.full}</title>`
        center = `<Center coords={coords.center} />` if coords.center
        abbr = `<Abbr name={name} coords={coords.abbr} type={region.type} />`
        unit = `<Unit model={model.unit} coords={this.props.coords} />` if model.unit
        dislodged = `<Unit model={model.dislodged} coords={this.props.coords} />` if model.dislodged
        embattled = `<Embattled coords={coords.unit.xc} />` if model.embattled and not model.unit

        check = isSelectable name, control

        React.DOM.g $.extend( { id: name, 'data-power':power }, check ),
          #title
          polygons
          center
          abbr
          embattled
          unit
          dislodged