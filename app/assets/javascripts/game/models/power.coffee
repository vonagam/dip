class model.Power
  constructor: ( @name )->
    @units = []
    @areas = []

  add_area: ( area )->
    area.power = this
    @areas.push area
    return

  supplies: ->
    supplies = []
    supplies.push area if area.supply() for area in @areas
    supplies
