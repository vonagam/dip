modulejs.define 'g.m.order.Support', ['g.m.order.Base'], ( Base )->

  class Support extends Base
    constructor: (unit, data)->
      super
      @type = 'Support'
      @from = data.from 
      @to = data.to

    to_json: ->
      j = super
      j['from'] = @from
      j['to'] = @to
      return j

    to_string: ->
      "S #{@from}#{ if @to != @from then ' -> '+@to else '' }"
