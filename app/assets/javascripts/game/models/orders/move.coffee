class model.Order.Move extends model.Order.Base
  constructor: ( unit, data )->
    super
    @type = 'Move'
    @to = data.to
    @target = @unit.areas @to.split('_')[0]

  create_visualization: ->
    from = @unit.coords
    to = @target.coords @to.split('_')[1]

    vec = to.dif(from).norm()

    f = from.sum( vec.mult(8) )
    t = to.sum( vec.mult(-12) )

    line = document.createElementNS 'http://www.w3.org/2000/svg', 'line'

    line = $ line

    line.attr 
      x1: f.x
      y1: f.y
      x2: t.x
      y2: t.y
    
    line.attr 'class', @view_class_name()

    return line

  to_json: ->
    j = super
    j['to'] = @to
    return j
