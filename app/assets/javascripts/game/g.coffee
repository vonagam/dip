@model = {}

@g = {}

g.initialize = ( status, state_type, state_data, power, orders )->
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


  g.map_model = new model.Map regions

  state = new model.State g.map_model, state_data, state_type
  
  g.map_model.set_state state

  return if status != 'in_process'

  if state_type == 'Move'
    g.set_order unit, 'Hold' for unit in state.units

  if orders
    if state_type == 'Move' || state_type == 'Retreat'
      whom = if state_type == 'Move' then 'unit' else 'dislodged'
      for area_name, order of orders
        unit = g.map_model.areas[ area_name.split('_')[0] ][whom]
        g.set_order unit, order.type, order

  switch state_type
    when 'Move' then g.move_state.turn true
    when 'Retreat' then g.retreat_state.turn true

  return
