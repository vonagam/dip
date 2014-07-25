modulejs.define 'm.g.order.Disband', ['m.g.order.Base'], ( Base )->

  class Disband extends Base
    constructor: ->
      super
      @type = 'Disband'

    to_string: -> 'D'
