modulejs.define 'm.g.Power', ->

  class Power
    constructor: ( @name )->
      @units = []
      @areas = []

    add_area: ( area )->
      area.power = this
      @areas.push area
      return

    supplies: ->
      area for area in @areas when area.supply()
