class g.model.Order.Build extends g.model.Order.Base
  constructor: ( area, sub_area = 'xc', data )->
    @type = 'Build'
    @unit = new g.model.Unit area.power, data.unit, area, sub_area
    super @unit, data
    @unit.set_order this

  remove: ->
    delete @unit.order
    delete @unit.area.unit

    index = @unit.power.units.indexOf @unit
    @unit.power.units.splice index, 1

    return

  to_json: ->
    j = super
    j['unit'] = @unit.type
    return j

  to_string: -> 'B'
