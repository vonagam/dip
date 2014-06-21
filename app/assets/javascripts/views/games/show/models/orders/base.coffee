g.set_order = ( unit, order_class, options )->
  unit.set_order( new g.model.Order[order_class]( unit, options ) )
  return

g.model.Order = {}

class g.model.Order.Base
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
