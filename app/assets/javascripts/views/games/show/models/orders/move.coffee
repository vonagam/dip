modulejs.define 'g.m.order.Move', ['g.m.order.Base'], ( Base )->

  class Move extends Base
    constructor: ( unit, data )->
      super
      @type = 'Move'
      @to = data.to
      @target = @unit.areas @to.split('_')[0]

    to_json: ->
      j = super
      j['to'] = @to
      return j

    to_string: ->
      "M -> #{@to}"
