###* @jsx React.DOM ###

g.view.Region = React.createClass
  render: ->
    Polygon = g.view.Polygon
    Center = g.view.Center
    Abbr = g.view.Abbr
    Unit = g.view.Unit
    Embattled = g.view.Embattled

    name = @props.name
    model = @props.model
    region = model.region()
    coords = @props.coords[name]
    control = @props.control
    power = model.power?.name

    polygons = []
    coords.polygons.forEach (polygon, index)->
      polygons.push `<Polygon key={index} region={name} polygon={polygon} control={control} />`
    
    title = `<title>{region.full}</title>`
    center = `<Center coords={coords.center} />` if coords.center
    abbr = `<Abbr name={name} coords={coords.abbr} type={region.type} />`
    unit = `<Unit model={model.unit} coords={this.props.coords} />` if model.unit
    dislodged = `<Unit model={model.dislodged} coords={this.props.coords} />` if model.dislodged
    embattled = `<Embattled coords={coords.unit.xc} />` if model.embattled and not model.unit

    check = g.view.isSelectable name, control

    React.DOM.g $.extend( { id: name, 'data-power':power }, check ),
      title
      polygons
      center
      abbr
      embattled
      unit
      dislodged
