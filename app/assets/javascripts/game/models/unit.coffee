class model.Unit
  constructor: ( @power, @type, @area, @sub_area, @dislodged )->
    @order = undefined
    @power.units.push this
    @status = if @dislodged then 'dislodged' else 'unit'

  attach: ->
    @coords = @area.coords @sub_area

    if @dislodged
      offset = @coords.dif( @areas( @dislodged ).coords() ).norm()
      @coords = @coords.sum( offset.scale(14) )

    force = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
    force.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#'+@type

    force = $(force)

    force.attr
      'class': "unit #{@power.name} #{ (@dislodged && 'dislodged') || '' }"
      'transform': "translate(#{@coords.x},#{@coords.y})"
    
    force.appendTo @area.view()

    @view = force
    @view.data 'model', this
    @area[@status] = this
    @order.attach() if @order
    return

  detach: ->
    @view.remove()
    @area[@status] = undefined
    @order.detach() if @order
    return

  set_order: (order)->
    @order.detach() if @order
    @order = order
    @order.attach() if @order
    return

  areas: ( name )->
    @area.state.areas[ name ]

  position: ->
    @area.name + ( if @sub_area == 'xc' then '' else "_#{@sub_area}" )

  neighbours: ->
    regions[@area.name][@sub_area]
