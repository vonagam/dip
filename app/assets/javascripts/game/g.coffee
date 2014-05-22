@model = {}

@g = {}

g.state = undefined
g.set_state = ( state )->
  g.state.detach() if g.state
  g.state = state
  g.state.attach() if g.state
  return

g.initialize = ( status, state_type, state_data, power, orders )->
  g.container = $ '#map.container'
  g.map = g.container.find '#diplomacy_map'
  g.areas = g.map.children('g').not '#Orders'
  g.stats = $ '#map_statistic tbody'

  g.power = power

  g.orders_visualizations =
    'old': g.map.find '#Orders_old'
    'new': g.map.find '#Orders_new'

  g.map.find('[data-coords]').each ()->
    q = $ this
    xy = q.attr('data-coords').split(',')
    q.data 'coords', new Vector({ x: parseInt(xy[0]), y: parseInt(xy[1]) })


  state = new model.State state_data, state_type
  
  g.set_state state

  return if status != 'started'

  if state_type == 'Move'
    for power_name, power_data of g.state.powers
      for unit in power_data.units
        g.set_order unit, 'Hold'

  if orders
    whom = if state_type == 'Retreat' then 'dislodged' else 'unit'
    for area_name, order of orders
      if order.type != 'Build'
        unit = g.state.get_area( area_name )[whom]
        g.set_order unit, order.type, order
      else
        position = area_name.split '_'
        new model.Order.Build( g.state.get_area(position[0]), order.unit, position[1] )

  g.game_phase[state_type].turn true
