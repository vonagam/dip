class g.model.Area
  constructor: ( @name, @state )->

    @targeting = {}

    #power
    #unit
    #dislodged
    #embattled

  view: ( sub = 'xc' )->
    g.map.find '#'+@name+( if sub == 'xc' then '' else '_'+sub )

  coords: ( sub ) ->
    @view(sub).data 'coords'

  attach: ->
    view = @view()

    view
    .attr 'class', if @power then @power.name else null
    .data 'model', this

    if @embattled and not @unit
      g.svgs.get 'embattled', 'embattled', @coords()
      .appendTo view

    return

  detach: ->
    @view()
    .removeAttr 'class'
    .data 'model', null
    .find('.embattled').remove()
    return

  region: ->
    regions[@name]
  supply: ->
    @region().supply
  type: ->
    @region().type
