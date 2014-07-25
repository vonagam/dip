modulejs.define 'm.g.order.Convoy', ['m.g.order.Base'], ( Base )->

  class Convoy extends Base
    constructor: (unit, data)->
      super
      @type = 'Convoy'
      @from = data.from
      @to = data.to

    to_json: ->
      j = super
      j['from'] = @from
      j['to'] = @to
      return j

    to_string: ->
      "C #{@from} -> #{@to}"
