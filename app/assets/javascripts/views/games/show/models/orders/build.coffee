class g.model.Order.Build extends g.model.Order.Base
  constructor: ( area, sub_area = 'xc', data )->
    @type = 'Build'
    @unit = new g.model.Unit area.power, data.unit, area, sub_area
    super @unit, data
    @unit.order = this

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
    g.svgs.get 'build', @view_class_name(), @unit.coords

  to_json: ->
    j = super
    j['unit'] = @unit.type
    return j

  to_string: -> 'B'
