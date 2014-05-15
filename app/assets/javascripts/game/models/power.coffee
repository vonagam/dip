class model.Power
  constructor: ( @name )->
    @units = []
    @areas = []

  add_area: ( area )->
    area.power = this
    @areas.push area
    return

  supplies: ->
    area for area in @areas when area.supply()

  attach: ->
    unit.attach() for unit in @units

  detach: ->
    unit.detach() for unit in @units
