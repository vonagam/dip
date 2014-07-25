modulejs.define 'm.g.order.Retreat', ['m.g.order.Move'], ( Move )->

  class Retreat extends Move
    constructor: ->
      super
      @type = 'Retreat'

    to_string: ->
      "R -> #{@to}"
