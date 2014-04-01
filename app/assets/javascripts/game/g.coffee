@g = {}

g.initialize_map = ( countries )->

  g.container = $ '#game_container'
  g.map = g.container.find '#diplomacy_map'
  g.places = g.map.children('g').not '#Orders'

  g.orders_visualizations =
    'old': g.map.find '#Orders_old'
    'new': g.map.find '#Orders_new'


  g.map.find('[data-coords]').each ()->
    q = $ this
    xy = q.attr('data-coords').split(',')
    xy[0] = parseInt xy[0]
    xy[1] = parseInt xy[1]
    q.data 'coords', xy


  place_force = (country, where, type)->
    address = where.split '_'

    coords = g.map.find('#'+where).data('coords')
    log address
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

  for country, data of countries
    for place, unit of data.units
      place_force country, place, if unit == 'A' then 'army' else 'fleet'

    for area in data.areas
      g.places.filter('#'+area).attr 'class', country 

  g.force_places = g.places.filter ()-> $(this).children('.force').length

  g.places.each ()-> 
    $(this).data 'targeting', {}

  g.map.find('.force').each ()->
    g.make.order 'hold', $(this)
