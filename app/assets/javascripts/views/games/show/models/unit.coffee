class g.model.Unit
  constructor: ( @power, @type, @area, @sub_area, @dislodged )->
    @order = undefined
    @power.units.push this
    @status = if @dislodged then 'dislodged' else 'unit'
    @area[@status] = this

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

  set_order: ( order )->
    @order?.detach()
    @order = order
    @order?.attach()

  can_go: ( area_type )->
    !((@type == 'army' && area_type == 'water') || (@type == 'fleet' && area_type == 'land'))
