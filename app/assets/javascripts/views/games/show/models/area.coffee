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
      coords = @coords()

      star = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
      star.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#embattled'

      star = $ star

      star.attr
        'class': "embattled"
        'transform': "translate(#{coords.x},#{coords.y})"
      
      star.appendTo view

  detach: ->
    @view()
    .removeAttr 'class'
    .data 'model', null
    .find('.embattled').remove()

  region: ->
    regions[@name]
  supply: ->
    @region().supply
  type: ->
    @region().type
