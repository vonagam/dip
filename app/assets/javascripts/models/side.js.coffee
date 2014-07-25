modulejs.define 'm.Side', ['m.Base'], (Base)->
  class Side extends Base
    attrs: [
      'id'
      'power'
      'name'
      'status'
      'orderable'
      'user'
      'game'
    ]

    get_name: ->
      return @name if @name
      return @power[0] if @power
      return 'Random'