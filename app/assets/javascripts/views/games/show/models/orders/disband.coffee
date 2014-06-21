class g.model.Order.Disband extends g.model.Order.Base
  constructor: ->
    super
    @type = 'Disband'

  to_string: -> 'D'
