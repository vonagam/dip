class model.Order.Build extends model.Order.Base
  constructor: ( area, type, sub_area = 'xc' )->
    @type = 'Build'
    @unit = new model.Unit area.power, type, area, sub_area
    super @unit
    @unit.order = this
    @unit.attach()

  remove: ->
    @unit.detach()

    delete @unit.order
    delete @unit.area.unit

    index = @unit.power.units.indexOf @unit
    @unit.power.units.splice index, 1
    return

  attach: ->
    @unit.area.view().attr 'builded', true
    super
    return

  detach: ->
    @unit.area.view().removeAttr 'builded'
    super
    return

  create_visualization: ->
    circle = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
    circle.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#build'
  
    circle = $ circle

    coords = @unit.coords

    circle.attr 
      'class': @view_class_name()
      'transform': "translate(#{coords.x},#{coords.y})"

    return circle

  to_json: ->
    j = super
    j['unit'] = @unit.type
    return j
