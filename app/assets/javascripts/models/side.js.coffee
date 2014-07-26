modulejs.define 'm.Side', ['m.Base'], (Base)->
  class extends Base
    model_name: 'side'
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

    is_creator: ->
      @game.creator == @user
