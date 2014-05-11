class klass.Order.Support extends klass.Order.Base
  constructor: (unit, data)->
    super
    @type = 'Support'
    @whom = @unit.area.map.areas[ data.from ].unit
    @to = data.to
    @to_where = @unit.area.map.areas[ data.to ].views['xc']

  create_visualization: ->
    supporter = @unit.where.data 'coords'
    from = @whom.where.data 'coords'
    to = @to_where.data 'coords'

    middle =
      x: (from[0]*1.2+to[0]*0.8)/2
      y: (from[1]*1.2+to[1]*0.8)/2

    theta = Math.atan2 middle.y-supporter[1], middle.x-supporter[0]

    supporter =
      x: supporter[0] + 8*Math.cos(theta)
      y: supporter[1] + 8*Math.sin(theta)

    if from == to
      middle =
        x: middle.x - 12*Math.cos(theta)
        y: middle.y - 12*Math.sin(theta)
    
    line = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
    
    line = $ line
    
    line.attr 
      'd': 'M'+supporter.x+','+supporter.y+'L'+middle.x+','+middle.y
      'class': "support #{@unit.power.name}"

    return line

  to_json: ->
    j = super
    j['from'] = @whom.area.name
    j['to'] = @to
    return j
