modulejs.define 'g.m.order.Retreat', ['g.m.order.Move'], ( Move )->

  class Retreat extends Move
    constructor: ->
      super
      @type = 'Retreat'

    to_string: ->
      "R -> #{@to}"
