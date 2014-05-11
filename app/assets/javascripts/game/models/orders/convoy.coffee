class klass.Order.Convoy extends klass.Order.Base
  constructor: (unit, data)->
    super
    @type = 'Convoy'
    @whom = @unit.area.map.areas[ data.from ].unit
    @to = data.to

  create_visualization: ->
    line = document.createElementNS 'http://www.w3.org/2000/svg', 'circle'
  
    line = $ line

    position = @unit.where.data 'coords'
    
    line.attr 
      'r': 10
      'cx': position[0]
      'cy': position[1]
      'class': "convoy #{@unit.power.name}"

    return line

  to_json: ->
    j = super
    j['from'] = @whom.area.name
    j['to'] = @to
    return j
