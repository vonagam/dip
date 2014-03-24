g.make.support = (who, whom)->
  position = who.parent()
  dislocation = position.attr('id')

  whom_order = whom.data('order')

  from = to = whom

  if whom_order.type == 'move'
    to = whom_order.position
    if whom_order.convoy
      from = whom_order.convoy.eq(-2)
    

  line = g.make.draw_support who, from, to

  g.orders_visualizations.new.append line

  who.data 'order',
    type: 'support'
    whom: whom
    to: to
    visual: line
    position: position

  position.data('targeting')[dislocation] = who
  
  whom.data('order').supporters[dislocation] = who

g.make.draw_support = (who, from, to)->
  supporter = who.data 'coords'
  from = from.data 'coords'
  to = to.data 'coords'

  middle =
    x: (from[0]*2+to[0])/3.0
    y: (from[1]*2+to[1])/3.0

  theta = Math.atan2 middle.y-supporter[1], middle.x-supporter[0]

  supporter =
    x: supporter[0] + 10*Math.cos(theta)
    y: supporter[1] + 10*Math.sin(theta)

  if from == to
    middle =
      x: middle.x - 10*Math.cos(theta)
      y: middle.y - 10*Math.sin(theta)
  

  line = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
  
  line = $ line
  
  line.attr 'd', 'M'+supporter.x+','+supporter.y+'L'+middle.x+','+middle.y
  line.attr 'class', 'support '+who.data('country')

  return line
