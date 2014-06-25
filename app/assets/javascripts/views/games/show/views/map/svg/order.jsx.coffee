###* @jsx React.DOM ###

modulejs.define 'g.v.map.svg.Order', [ 'g.v.map.svg.unit_coords' ], ( c )->

  React.createClass
    Circle: ->
      `<circle 
        className={this.className} data-status={this.status} 
        transform={this.transform} r='10' 
      />`
    Line: ->
      from = c.unit_coords @coords, @order.unit
      to = c.full_coords @coords, @order.to

      vec = to.dif(from).norm()

      f = from.sum vec.mult 8
      t = to.sum vec.mult -12

      `<line 
        className={this.className} data-status={this.status} 
        x1={f.x} y1={f.y} x2={t.x} y2={t.y} 
      />`
    Disband: ->
      `<g className={this.className} data-status={this.status} transform={this.transform}>
        <line x1='-5' y1='-5' x2='5' y2='5'/>
        <line x1='-5' y1='5' x2='5' y2='-5'/>
      </g>`
    Support: ->
      supporter = c.unit_coords @coords, @order.unit
      from = c.unit_coords @coords, @order.unit.areas( @order.from ).unit
      to = c.full_coords @coords, @order.to

      vec = from.dif(supporter).norm()

      supporter = supporter.sum vec.mult 8

      d = 'M'+supporter

      if @order.to == @order.from
        from.sub vec.mult 12
        d += 'L'+from
      else
        to.add( from ).scale 0.5
        d += 'Q'+from+' '+to

      `<path className={this.className} data-status={this.status} d={d} />`
    Move: -> @Line()
    Retreat: -> @Line()
    Build: -> @Circle()
    Convoy: -> @Circle()
    render: ->
      @coords = @props.coords
      @order = @props.order
      @className = "#{@order.type} #{@order.unit.power.name}"
      @status = @order.status
      @transform = c.translate c.unit_coords @coords, @order.unit

      @[@order.type]()
