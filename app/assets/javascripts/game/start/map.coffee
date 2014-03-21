g.initialize_map = ( countries )->

  g.container = $ '#game_container'
  g.map = g.container.find '#diplomacy_map'

  g.orders_visualizations =
    'old': g.map.find('#Orders_old')
    'new': g.map.find('#Orders_new')

  g.map.find('[data-coords]').each ()->
    xy = $(this).attr('data-coords').split(',')
    xy[0] = parseInt(xy[0])
    xy[1] = parseInt(xy[1])
    $(this).data('coords', xy)


  g.places = g.map.children('g').not '#Orders'

  place_force = (country, where, type)->
    address = where.split '_'
    
    region = @regions[address[0]]
    
    if address.length == 2
      pos = address[1]
    else
      pos = if type == 'army' then 'mv' else 'xc'

    coords = g.map.find('#'+where).data('coords')

    force = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
    force.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#'+type

    force = $(force)

    force.attr 'class', 'force '+country
    force.attr 'transform', 'translate('+coords.join(',')+')'
    
    force.appendTo g.places.filter('#'+address[0])
    
    force.data 'neighbours', region[pos]
    force.data 'country', country
    force.data 'where', where
    force.data 'type', type
    force.data 'coords', coords
    force.data 'address', address[0]

  for country, data of countries
    place_force country, army_place,  'army'  for army_place  in data['Power']['Army']
    place_force country, fleet_place, 'fleet' for fleet_place in data['Power']['Fleet']
    g.places.filter('#'+land)[0].setAttribute 'class', country for land in data['Lands']
