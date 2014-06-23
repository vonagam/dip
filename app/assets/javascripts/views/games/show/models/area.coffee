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

    add = ( array )-> all = all.concat array

    if lands = neis.land
      add lands

    if waters = neis.water
      if $.isArray waters
        add waters
      else
        for sub, water of waters
          add water

    all

  possible_builds: ->
    builds = []

    neis = @regions().neis

    if neis.land
      builds.push sub: 'xc', type: 'army'

    if waters = neis.water
      if $.isArray waters
        builds.push sub: 'xc', type: 'fleet'
      else
        for sub, water of waters
          builds.push sub: sub, type: 'fleet'

    builds
