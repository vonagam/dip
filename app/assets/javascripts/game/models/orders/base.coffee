g.set_order = ( unit, order_class, options )->
  unit.set_order( new model.Order[order_class]( unit, options ) )
  return

model.Order = {}

class model.Order.Base
  constructor: ( @unit, data )->
    @status = data.result if data
    @target = @unit.area
  
  attach: ->
    @visualization = @create_visualization()
    g.orders_visualizations.append @visualization
    @target.targeting[ @unit.area.name ] = this
    return

  detach: ->
    @visualization.remove()
    delete @visualization
    delete @target.targeting[ @unit.area.name ]
    return

  create_visualization: ->
    return $()

  to_json: ->
    return { type: @type }

  view_class_name: ->
    "#{@type} #{@unit.power.name} #{@status}"
