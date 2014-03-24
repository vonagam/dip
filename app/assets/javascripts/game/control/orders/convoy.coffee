g.make.convoy = (who, regions)->
  regions = $ regions
  destination = regions.last()
  path = ''

  for i in [1..regions.length-1]
    path += g.make.convoy_segment regions.eq(i-1), regions.eq(i)

  line = g.make.draw_convoy who, path

  g.orders_visualizations.new.append line
  
  who.data 'order',
    type: 'move'
    convoy: regions
    position: destination
    visual: line

  destination.data('targeting')[who.parent().attr('id')] = who

  for i in [1..regions.length-2]
    fleet = regions.eq(i).children '.force'
    g.make.order 'fleet_convoy', fleet, who, regions.last


g.make.convoy_segment = (start, finish)->
  from = start.data 'coords'
  to = finish.data 'coords'

  theta = Math.atan2 to[1]-from[1], to[0]-from[0]

  f =
    x: from[0] + 10*Math.cos(theta)
    y: from[1] + 10*Math.sin(theta)
  
  t =
    x: to[0] - 10*Math.cos(theta)
    y: to[1] - 10*Math.sin(theta)

  return 'M'+f.x+','+f.y+'L'+t.x+','+t.y


g.make.draw_convoy = (who, path)->
  line = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
  
  line = $ line
  
  line.attr 'd', path
  line.attr 'class', 'convoy '+who.data('country')

  return line


g.make.fleet_convoy = (who, whom, to)->
  line = g.make.draw_fleet_convoy who

  g.orders_visualizations.new.append line
  
  who.data 'order',
    type: 'convoy'
    whom: whom
    to: to
    position: who.parent()
    visual: line

  who.parent().data('targeting')[who.parent().attr('id')] = who

g.make.draw_fleet_convoy = (who)->
  line = document.createElementNS 'http://www.w3.org/2000/svg', 'circle'
  
  line = $ line

  position = who.data 'coords'
  
  line.attr 'r', 10
  line.attr 'cx', position[0]
  line.attr 'cy', position[1]
  line.attr 'class', 'convoy '+who.data('country')

  return line
