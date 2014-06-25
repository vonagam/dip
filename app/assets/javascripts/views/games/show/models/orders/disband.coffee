modulejs.define 'g.m.order.Disband', ['g.m.order.Base'], ( Base )->

  class Disband extends Base
    constructor: ->
      super
      @type = 'Disband'

    to_string: -> 'D'
