class model.Order.Convoy extends model.Order.Base
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
      'cx': position.x
      'cy': position.y
      'class': "convoy #{@unit.power.name}"

    return line

  to_json: ->
    j = super
    j['from'] = @whom.area.name
    j['to'] = @to
    return j
