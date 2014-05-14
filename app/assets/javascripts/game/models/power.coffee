class model.Power
  constructor: ( @name )->
    @units = []
    @areas = []

  attach: ->
    area.views.xc.attr 'class', @name for area in @areas

  detach: ->
    area.views.xc.removeAttr 'class' for area in @areas

  supply: ->
    supply = []
    supply.push area if area.supply for area in @areas
    supply
