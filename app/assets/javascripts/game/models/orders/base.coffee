g.set_order = ( unit, order_class, options )->
  unit.set_order( new klass.Order[order_class]( unit, options ) )
  return

klass.Order = {}

class klass.Order.Base
  constructor: ( unit, data )->
    @unit = unit
    @status = data

    @target = unit.area
    @to_where = unit.where
  
  attach: ->
    @visualization = @create_visualization()
    g.orders_visualizations.new.append @visualization
    @target.targeting[ @unit.area.name ] = this
    return

  detach: ->
    @visualization.remove()
    delete @target.targeting[ @unit.area.name ]
    return

  create_visualization: ->
    return $()

  toggle: ( bool )->
    @visualization.toggle bool
    return

  to_json: ->
    return { type: @type }
