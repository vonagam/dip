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
    klass = "unit #{@power.name} #{ (@dislodged && 'dislodged') || '' }"

    @view = g.svgs.get @type, klass, @coords

    @view
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
    neis = @area.region().neis

    if @type == 'army'
      neis.land
    else
      if $.isArray neis.water
        neis.water
      else
        neis.water[@sub_area]

  can_go: ( area_type )->
    !((@type == 'army' && area_type == 'water') || (@type == 'fleet' && area_type == 'land'))
