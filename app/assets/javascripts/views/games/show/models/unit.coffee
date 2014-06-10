class g.model.Unit
  constructor: ( @power, @type, @area, @sub_area, @dislodged )->
    @order = undefined
    @power.units.push this
    @status = if @dislodged then 'dislodged' else 'unit'
    @area[@status] = this

    @coords = @area.coords @sub_area
    if @dislodged
      offset = @coords.dif( @areas( @dislodged ).coords() ).norm()
      @coords = @coords.sum( offset.scale(14) )

  attach: ->
    @view = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
    @view.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#'+@type

    @view = $ @view

    @view
    .attr
      'class': "unit #{@power.name} #{ (@dislodged && 'dislodged') || '' }"
      'transform': "translate(#{@coords.x},#{@coords.y})"
    .data 'model': this
    .appendTo @area.view()

    @order.attach() if @order
    return

  detach: ->
    @view.remove()
    delete @view
    @order.detach() if @order
    return

  set_order: (order)->
    @order.detach() if @order && @view
    @order = order
    @order.attach() if @order && @view
    return

  areas: ( name )->
    @area.state.areas[ name ]

  position: ->
    @area.name + ( if @sub_area == 'xc' then '' else "_#{@sub_area}" )

  neighbours: ->
    regions[@area.name][@sub_area]

  can_go: ( area_type )->
    !((@type == 'army' && area_type == 'water') || (@type == 'fleet' && area_type == 'land'))
