class window.Vector

  constructor: (v) ->
    @x = v.x || 0
    @y = v.y || 0

  set: (v) ->
    @x = v.x if v.x != undefined 
    @y = v.y if v.y != undefined
    @

  clone: ->
    new Vector @

  add: (v) ->
    @x += v.x if v.x != undefined 
    @y += v.y if v.y != undefined
    @

  sum: (v) ->
    new Vector x: @x + v.x, y: @y + v.y

  sub: (v) ->
    @x -= v.x if v.x != undefined 
    @y -= v.y if v.y != undefined
    @

  dif: (v) ->
    new Vector x: @x - v.x, y: @y - v.y

  scale: (f) ->
    @x *= f 
    @y *= f 
    @

  length: ->
    Math.sqrt @x*@x + @y*@y

  dist: (v) ->
    @dif(v).length()

  norm: ->
    @scale 1/@length()

  rotate: (angle) ->
    sin = Math.sin angle
    cos = Math.cos angle
    @x = cos * @x - sin * @y
    @y = sin * @x + cos * @y
    @

  angle: ->
    Math.acos( v.x / Math.sqrt(v.x*v.x + v.y*v.y) )


