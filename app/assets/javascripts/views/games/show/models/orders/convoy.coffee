class g.model.Order.Convoy extends g.model.Order.Base
  constructor: (unit, data)->
    super
    @type = 'Convoy'
    @from = data.from
    @to = data.to

  create_visualization: ->
    circle = document.createElementNS 'http://www.w3.org/2000/svg', 'circle'
  
    circle = $ circle

    position = @unit.coords
    
    circle.attr 
      'r': 10
      'cx': position.x
      'cy': position.y
      'class': @view_class_name()

    return circle

  to_json: ->
    j = super
    j['from'] = @from
    j['to'] = @to
    return j