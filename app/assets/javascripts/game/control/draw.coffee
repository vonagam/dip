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
    x: (from[0]+to[0])/2.0
    y: (from[1]+to[1])/2.0
  mid1 =
    x: (3*from[0]+to[0])/4.0
    y: (3*from[1]+to[1])/4.0
  mid2 = 
    x: (from[0]+3*to[0])/4.0
    y: (from[1]+3*to[1])/4.0
  
  offset = {}

  if to[0] > from[0]
    offset.x = 0.05*(to[1] - from[1])
    offset.y = 0.05*(from[0] - to[0])
  else
    offset.x = 0.05*(from[1] - to[1])
    offset.y = 0.05*(to[0] - from[0])

  cp1 = 
    x: mid1.x + offset.x 
    y: mid1.y + offset.y

  arcpath = ['M',supporter[0],',',supporter[1],'C',m.x,',',m.y,' ',cp1.x,',',cp1.y,' ',mid2.x,',',mid2.y].join('')    

  line = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
  line = $ line
  line.attr 'd', arcpath

  return line
