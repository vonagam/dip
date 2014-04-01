g.make.move = (who, where)->
  line = g.make.draw_move who, where
  
  g.orders_visualizations.new.append line
  
  who.data 'order',
    type: 'move'
    position: where
    visual: line

  where.closest('g').data('targeting')[who.parent().attr('id')] = who


g.make.draw_move = (who, where)->
  from = who.data 'coords'
  to = where.data 'coords'

  theta = Math.atan2 to[1]-from[1], to[0]-from[0]

  f =
    x: from[0] + 8*Math.cos(theta)
    y: from[1] + 8*Math.sin(theta)
  
  t =
    x: to[0] - 12*Math.cos(theta)
    y: to[1] - 12*Math.sin(theta)

  line = document.createElementNS 'http://www.w3.org/2000/svg', 'line'

  line = $ line

  line.attr 'x1', f.x
  line.attr 'y1', f.y
  line.attr 'x2', t.x
  line.attr 'y2', t.y
  
  line.attr 'class', 'move '+who.data('country')
