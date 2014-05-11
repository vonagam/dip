class klass.Power
  constructor: ( @name )->
    @units = []
    @areas = []

  attach: ->
    area.views.xc.attr 'class', @name for area in @areas

  detach: ->
    area.views.xc.removeAttr 'class' for area in @areas
