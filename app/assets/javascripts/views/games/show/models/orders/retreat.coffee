class g.model.Order.Retreat extends g.model.Order.Move
  constructor: ->
    super
    @type = 'Retreat'

  to_string: ->
    "R -> #{@to}"
