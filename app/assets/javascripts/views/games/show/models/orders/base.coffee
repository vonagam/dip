modulejs.define 'g.m.order.Base', ->

  class Order
    constructor: ( @unit, data )->
      @status = data.result if data
      @target = @unit.area
    
    attach: ->
      @target.targeting[ @unit.area.name ] = this
      return

    detach: ->
      delete @target.targeting[ @unit.area.name ]
      return

    to_json: ->
      type: @type

    view_class_name: ->
      "#{@type} #{@unit.power.name} #{@status}"
