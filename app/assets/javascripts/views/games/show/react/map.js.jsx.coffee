###* @jsx React.DOM ###



translate = ( coords )-> "translate(#{ new Vector coords })"



ChekOrderControl = ( name, order_control )->
  if order_control && order_control[0].indexOf(name) != -1
    'data-selectable': true, 'onMouseDown': order_control[1].bind this, name
  else
    'data-selectable': null, 'onMouseDown': null



Orders =
  Move:
    first: ->
      state = @props.game.state

      selectable = [] 
      for name, power of state.powers
        for unit in power.units
          selectable.push unit.area.name

      order_callback = ( name )=>
        area = state.get_area name
        unit = area.unit
        Orders.Move.move.call this, unit
        
        @forceUpdate()
        return

      @control = [ selectable, order_callback ]
      return

    move: ( unit )->
      state = @props.game.state

      if unit.type == 'army'
        selectable = []

        for nei_name in unit.area.neighbours()
          nei_area = state.get_area nei_name
          continue if nei_area.type() == 'water' && !nei_area.unit
          selectable.push nei_name

      else
        selectable = unit.neighbours()

      order_callback = ( name )=>
        target = state.get_area name

        if unit.can_go target.type()
          if target == unit.area
            g.set_order unit, 'Hold'
          else
            g.set_order unit, 'Move', to: name
          Orders.Move.first.call this
        else
          if unit.type == 'army' && target.type() == 'water'
            fleet = target.unit
            Orders.Move.convoy.call this, unit, [fleet]
        
        @forceUpdate()
        return

      @control = [ selectable, order_callback ]
      return

    convoy: ( army, fleets )->
      state = @props.game.state

      last = fleets[0]

      selectable = []

      for possibility in last.area.neighbours()
        pos_area = state.get_area possibility

        if pos_area.type() != 'water' || pos_area.unit
          selectable.push pos_area.name

      units_areas = fleets.concat( army ).map (unit)-> unit.area.name

      selectable = selectable.filter (area_name)->
        units_areas.indexOf(area_name) == -1

      order_callback = ( name )=>
        target = state.get_area name

        if target.type() == 'water'
          Orders.Move.convoy.call this, army, fleets.concat target.unit
        else
          g.set_order army, 'Move', to: name

          for fleet in fleets
            g.set_order fleet, 'Convoy', to: name, from: army.area.name

          Orders.Move.first.call this

        @forceUpdate()
        return

      @control = [ selectable, order_callback ]
      return






vr.Map = React.createClass
  getInitialState: ->
    hide_abbrs: $.cookie('hide_abbrs') == 'true'
  toggleAbbrs: ->
    hide = !@state.hide_abbrs
    @setState hide_abbrs: hide
    $.cookie 'hide_abbrs', hide
    return
  render: ->
    className = vr.classes 'map_container container', hide_abbrs: @state.hide_abbrs

    if @props.game.data.status == 'going' && @props.game.state.last
      className.add @props.page.last.raw.type
      Orders.Move.first.apply this if !@control
    else
      @control = null

    game_state = @props.game.state
    
    `<div className={className}>
      <SvgMap state={game_state} coords={this.props.coords} control={this.control} />
      <Stats state={game_state} />
      <AbbrToggler hide_abbrs={this.state.hide_abbrs} callback={this.toggleAbbrs} />
    </div>`



SvgMap = React.createClass
  render: ->
    state = @props.state
    regions_coords = @props.coords.regions

    viewBox = "0 0 #{@props.coords.viewBox[0]} #{@props.coords.viewBox[1]}"

    regions = []
    for name, coords of regions_coords
      model = state.areas[ name ]
      regions.push `<Region 
        key={name} 
        name={name} 
        coords={regions_coords} 
        model={model}
        control={this.props.control}
      />`

    orders = []
    for name, power of state.powers
      for unit in power.units
        if order = unit.order
          continue if order.type == 'Hold'
          orders.push `<Order 
            key={unit.area.name+'_'+order.type} 
            order={order} 
            coords={regions_coords} 
          />`

    ###
    <marker id='move_marker' markerWidth='8' markerHeight='10' refx='3' refy='5' orient='auto'>
      <polygon points='2,2 6,5 2,8'/>
    </marker>
    <marker id='support_marker' markerWidth='3' markerHeight='3' refx='1.5' refy='1.5'>
      <circle cx='1.5' cy='1.5' r='1.5'/>
    </marker>
    ###

    `<div className='keep_ratio'>
      <svg id='diplomacy_map' viewBox={viewBox}>
        <defs>
        </defs>
        <g id='regions'>{regions}</g>
        <g id='orders'>{orders}</g>
      </svg>
    </div>`



Region = React.createClass
  render: ->
    name = @props.name
    model = @props.model
    region = model.region()
    coords = @props.coords[name]
    control = @props.control

    className = vr.classes model.power?.name

    polygons = []
    coords.polygons.forEach (polygon, index)->
      polygons.push `<Polygon key={index} region={name} polygon={polygon} control={control} />`
    
    title = `<title>{region.full}</title>`
    center = `<Center coords={coords.center} />` if coords.center
    abbr = `<Abbr name={name} coords={coords.abbr} type={region.type} />`
    unit = `<Unit model={model.unit} coords={this.props.coords} />` if model.unit
    dislodged = `<Unit model={model.dislodged} coords={this.props.coords} />` if model.dislodged
    embattled = `<Embattled coords={coords.unit.xc} />` if model.embattled and not model.unit

    check = ChekOrderControl name, control
    
    `<g 
      id={name} 
      className={className} 
      data-selectable={check['data-selectable']}
      onMouseDown={check['onMouseDown']}
    >
      {title}
      {polygons}
      {center}
      {abbr}
      {unit}
      {dislodged}
      {embattled}
    </g>`



Polygon = React.createClass
  render: ->
    polygon = @props.polygon

    options = className: polygon.type
    
    if polygon.part
      options.id = "#{@props.region}_#{polygon.part}"
      $.merge options, ChekOrderControl options.id, @props.control

    if polygon.d
      options.d = polygon.d
      type = 'path'
    else
      options.points = polygon.points
      type = if polygon.part then 'polyline' else 'polygon'

    React.DOM[type]( options )



Center = React.createClass
  render: ->
    `<circle 
      className='center' 
      r='3'
      cx={this.props.coords.x}
      cy={this.props.coords.y}
    />`



Abbr = React.createClass
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



Unit = React.createClass
  render: ->
    unit = @props.model
    points = if unit.type == 'army' then '-4,-4 -4,4 4,4 4,-4' else '-6,-2 0,5 6,-2'
    className = vr.classes 'unit', unit.type, unit.power.name, dislodged: unit.dislodged

    coords = unit_coords @props.coords, unit

    if unit.dislodged
      from = new Vector @props.coords[ @dislodged ].unit.xc
      coords.add coords.dif( from ).norm().scale 14

    transform = translate coords

    `<polygon className={className} points={points} transform={transform} />`



Embattled = React.createClass
  render: ->
    `<polygon
      className='embattled'
      points='0,-5 1.5,-2 4.8,-1.5 2.4,0.8 3,4 0,2.5 -3,4 -2.4,0.8 -4.8,-1.5 -1.5,-2'
      transform={ translate( this.props.coords ) }
    />`



part_coords = ( coords, region, part )->
  new Vector coords[ region ].unit[ part ]
unit_coords = ( coords, unit )->
  part_coords coords, unit.area.name, unit.sub_area
full_coords = ( coords, full_name )->
  parts = full_name.split '_'
  part_coords coords, parts[0], parts[1] || 'xc'


Order = React.createClass
  Circle: ->
    `<circle className={this.className} transform={this.transform} r='10' />`
  Line: ->
    from = unit_coords @coords, @order.unit
    to = full_coords @coords, @order.to

    vec = to.dif(from).norm()

    f = from.sum vec.mult 8
    t = to.sum vec.mult -12

    `<line className={this.className} x1={f.x} y1={f.y} x2={t.x} y2={t.y} />`
  Disband: ->
    `<g className={this.className} transform={this.transform}>
      <line x1='-5' y1='-5' x2='5' y2='5'/>
      <line x1='-5' y1='5' x2='5' y2='-5'/>
    </g>`
  Support: ->
    supporter = unit_coords @coords, @order.unit
    from = unit_coords @coords, @order.unit.areas( @order.from ).unit
    to = full_coords @coords, @order.to

    vec = from.dif(supporter).norm()

    supporter = supporter.sum vec.mult 8

    d = 'M'+supporter

    if to == from 
      to.sub vec.mult 12
      d += 'L'+to
    else
      to.add( from ).scale 0.5
      d += 'Q'+from+' '+to

    `<path className={this.className} d={d} />`
  Move: -> @Line()
  Retreat: -> @Line()
  Build: -> @Circle()
  Convoy: -> @Circle()
  render: ->
    @coords = @props.coords
    @order = @props.order
    @className = "#{@order.type} #{@order.unit.power.name} #{@order.status}"
    @transform = translate unit_coords @coords, @order.unit

    @[@order.type]()



Stats = React.createClass
  render: ->
    powers = []

    for name, power of @props.state.powers
      powers.push `<tr key={name} className={name}>
        <td className='power'>{name}</td>
        <td className='supplies'>{power.units.length}</td>
        <td className='units'>{power.supplies().length}</td>
      </tr>`

    `<div className='stats container'>
      <div className='word'>statistic</div>
      <div className='container'>
        <table>
          <thead>
            <tr><th>power</th><th>supplies</th><th>units</th></tr>
          </thead>
          <tbody>
            {powers}
          </tbody>
        </table>
      </div>
    </div>`



AbbrToggler = React.createClass
  onMouseDown: (e)->
    @props.callback()
    vr.stop_event e
    return
  render: ->
    className = vr.classes 'abbrs container', hidden: @props.hide_abbrs
    `<div className={className} onMouseDown={this.onMouseDown}> 
      abbs
    </div>`


###
TODO
.old_order.j_component
= render 'games/show/order_type'
###
