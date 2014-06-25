modulejs.define 'g.m.order.Hold', ['g.m.order.Base'], ( Base )->

  class Hold extends Base
    constructor: ->
      super
      @type = 'Hold'

    to_string: -> 'H'
