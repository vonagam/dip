class g.model.Order.Hold extends g.model.Order.Base
  constructor: ->
    super
    @type = 'Hold'

  to_string: -> 'H'
