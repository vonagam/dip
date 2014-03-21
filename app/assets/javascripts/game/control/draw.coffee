@drawMove = (from, to)->
  theta = Math.atan2 to[1]-from[1], to[0]-from[0]

  f =
    x: from[0] + 10*Math.cos(theta)
    y: from[1] + 10*Math.sin(theta)
  
  t =
    x: to[0] - 10*Math.cos(theta)
    y: to[1] - 10*Math.sin(theta)

  line = document.createElementNS 'http://www.w3.org/2000/svg', 'line'

  line = $ line

  line.attr 'x1', f.x
  line.attr 'y1', f.y
  line.attr 'x2', t.x
  line.attr 'y2', t.y
    
  return line

@drawSupport = (supporter, from, to)->
  m = 
    x: (from.x+to.x)/2.0
    y: (from.y+to.y)/2.0
  mid1 =
    x: (3*from.x+to.x)/4.0
    y: (3*from.y+to.y)/4.0
  mid2 = 
    x: (from.x+3*to.x)/4.0
    y: (from.y+3*to.y)/4.0
  
  offset = {}

  if to.x > from.x
    offset.x = 0.05*(to.y - from.y)
    offset.y = 0.05*(from.x - to.x)
  else
    offset.x = 0.05*(from.y - to.y)
    offset.y = 0.05*(to.x - from.x)

  cp1 = 
    x: mid1.x + offset.x 
    y: mid1.y + offset.y

  arcpath = ['M',supporter.x,',',supporter.y,'C',m.x,',',m.y,' ',cp1.x,',',cp1.y,' ',mid2.x,',',mid2.y].join('')    

  line = document.createElementNS 'http://www.w3.org/2000/svg', 'line'
  line = $ line
  line.attr 'd', arcpath

  return line
