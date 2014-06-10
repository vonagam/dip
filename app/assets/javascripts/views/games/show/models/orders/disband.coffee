class g.model.Order.Disband extends g.model.Order.Base
  constructor: ->
    super
    @type = 'Disband'

  create_visualization: ->
    cross = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
    cross.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#disband'
  
    cross = $ cross

    coords = @unit.coords

    cross.attr 
      'class': @view_class_name()
      'transform': "translate(#{coords.x},#{coords.y})"

    return cross
