modulejs.define 'm.g.order.Hold', ['m.g.order.Base'], ( Base )->

  class Hold extends Base
    constructor: ->
      super
      @type = 'Hold'

    to_string: -> 'H'
