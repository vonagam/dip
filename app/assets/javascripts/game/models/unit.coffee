class klass.Unit
  constructor: ( @power, @type, @area, @sub_area )->
    @order = undefined
    @power.units.push this
    @where = @area.views[@sub_area]
    @neighbours = regions[@area.name][@sub_area]
    @attached = false

  attach: ->
    coords = @where.data 'coords'

    force = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
    force.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#'+@type

    force = $(force)

    force.attr 
      'class': "unit #{@power.name}"
      'transform': "translate(#{coords.join(',')})"
    
    force.appendTo @area.views.xc

    @view = force
    @view.data 'model', this
    @area.unit = this

    @attached = true

    @attach_order()
    return

  detach: ->
    @view.remove()
    @area.unit = undefined
    @order.detach() if @order

    @attached = false
    return

  toggle_orders: (bool)->
    @order.toggle bool if @order
    return

  attach_order: ->
    if @attached && @order
      @order.attach()
      @toggle_orders @area.map.show_orders
    return

  set_order: (order)->
    @order.detach() if @order
    @order = order
    @attach_order()
    return

  get_full_position: ->
    @area.name + ( if @sub_area == 'xc' then '' else "_#{@sub_area}" )
