@g = {}

place_force = (country, where, type)->
  address = where.split '_'

  coords = g.map.find('#'+where).data('coords')
  neighbours = @regions[address[0]][address[1] || 'neis']

  force = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
  force.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#'+type

  force = $(force)

  force.attr 'class', 'force '+country
  force.attr 'transform', 'translate('+coords.join(',')+')'
  
  force.appendTo g.places.filter('#'+address[0])
  
  force.data 
    type: type
    where: where
    coords: coords
    country: country
    neighbours: neighbours

place_order = (region, order)->
  who = g.map.find( '#'+region ).closest('g').children('.force')

  if order.type == 'hold'
    g.make.order 'hold', who
    return

  if order.type == 'move'
    g.make.order 'move', who, g.map.find('#'+order.to)
    return

  whom = g.map.find( '#'+order.from ).closest('g').children('.force')

  if order.to != whom.data('where') && whom.data('order').type != 'move' 
    place_order whom.data('where'), { type: 'move', to: order.to }

  if order.type == 'support' 
    g.make.order 'support', who, whom
    return

g.initialize = ( status, type, state, country, orders )->

  g.container = $ '#game ._map_container'
  g.map = g.container.find '#diplomacy_map'
  g.places = g.map.children('g').not '#Orders'

  g.country = country

  g.orders_visualizations =
    'old': g.map.find '#Orders_old'
    'new': g.map.find '#Orders_new'

  g.map.find('[data-coords]').each ()->
    q = $ this
    xy = q.attr('data-coords').split(',')
    xy[0] = parseInt xy[0]
    xy[1] = parseInt xy[1]
    q.data 'coords', xy

  for country, data of state.Powers
    for unit in data.Force
      if unit_data = unit.match(/^([AF])(\w+)$/)
        place_force country, unit_data[2], if unit_data[1] == 'A' then 'army' else 'fleet'

    for area in data.Lands
      g.places.filter('#'+area).attr 'class', country

  g.forces = g.map.find '.force'
  g.force_places = g.forces.parent()

  g.places.each ()-> $(this).data 'targeting', {}
  g.forces.each ()-> g.make.order 'hold', $(this)

  if status == 'in_process'
    if type == 'State::Move'
      g.order_index.turn true

  if country && orders
    for region, order of orders
      place_order region, order

g.get_orders = (country)->
  result = {}

  g.forces.filter ()->
    $(this).data('country') == country
  .each ()->
    q = $ this
    result[ q.data('where') ] = q.data('order')

  return result
