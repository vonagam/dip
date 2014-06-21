class g.model.Area
  constructor: ( @name, @state )->

    @targeting = {}

    #power
    #unit
    #dislodged
    #embattled

  region: ->
    regions[@name]
  supply: ->
    @region().center
  type: ->
    @region().type

  neighbours: ->
    all = []
    neis = @region().neis

    add = (array)->
      Array.prototype.push.apply all, array
      return

    if lands = neis.land
      add lands

    if waters = neis.water
      if $.isArray waters
        add waters
      else
        for sub, water of waters
          add water

    return all
