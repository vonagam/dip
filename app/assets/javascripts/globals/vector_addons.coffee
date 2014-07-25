Vector::toString = ->
  @x + ',' + @y

Vector::valueOf = ->
  @toString()

Vector::eq = ( vector )->
  @x == vector.x && @y == vector.y
