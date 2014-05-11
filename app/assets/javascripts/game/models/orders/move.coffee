class klass.Order.Move extends klass.Order.Base
  constructor: (unit, data)->
    super
    @type = 'Move'

    @to = data['to']

    to_info = @to.split '_'

    @target = @unit.area.map.areas[to_info[0]]
    @sub_target = to_info[1] || 'xc'
    @to_where = @target.views[@sub_target]

  create_visualization: ->
    from = @unit.where.data 'coords'
    to = @to_where.data 'coords'

    theta = Math.atan2 to[1]-from[1], to[0]-from[0]

    f =
      x: from[0] + 8*Math.cos(theta)
      y: from[1] + 8*Math.sin(theta)
    
    t =
      x: to[0] - 12*Math.cos(theta)
      y: to[1] - 12*Math.sin(theta)

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
