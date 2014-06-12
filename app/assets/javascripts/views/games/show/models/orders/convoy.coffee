class g.model.Order.Convoy extends g.model.Order.Base
  constructor: (unit, data)->
    super
    @type = 'Convoy'
    @from = data.from
    @to = data.to

  create_visualization: ->
    g.svgs.get 'convoy', @view_class_name(), @unit.coords

  to_json: ->
    j = super
    j['from'] = @from
    j['to'] = @to
    return j

  to_string: ->
    "C #{@from} -> #{@to}"
