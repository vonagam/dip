class model.Order.Move extends model.Order.Base
  constructor: (unit, data)->
    super
    @type = 'Move'

    @to = data['to']

    to_info = @to.split '_'

    @target = @unit.area.map.areas[to_info[0]]
    @sub_target = to_info[1] || 'xc'
    @to_where = @target.views[@sub_target]

  create_visualization: ->
    from = @unit.coords
    to = @to_where.data 'coords'

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
    
    line.attr 'class', "move #{@unit.power.name}"

    return line

  to_json: ->
    j = super
    j['to'] = @to
    return j
