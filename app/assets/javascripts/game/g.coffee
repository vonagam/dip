@g = {}

g.initialize = ( status, type, state, power, orders )->
  g.container = $ '#game ._map_container'
  g.map = g.container.find '#diplomacy_map'
  g.areas = g.map.children('g').not '#Orders'

  g.power = power

  g.orders_visualizations =
    'old': g.map.find '#Orders_old'
    'new': g.map.find '#Orders_new'

  g.map.find('[data-coords]').each ()->
    q = $ this
    xy = q.attr('data-coords').split(',')
    q.data 'coords', new Vector({ x: parseInt(xy[0]), y: parseInt(xy[1]) })


  g.map_model = new klass.Map regions

  state = new klass.MapState g.map_model, state
  
  g.map_model.set_state state

  g.set_order unit, 'Hold' for unit in state.units

  if orders
    for area_name, order of orders
      unit = g.map_model.areas[ area_name.split('_')[0] ].unit
      g.set_order unit, order.type, order

  if status == 'in_process'
    if type == 'State::Move'
      g.order_index.turn true

  return
