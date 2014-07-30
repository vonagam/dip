modulejs.define 'm.Side', ['m.Base'], (Base)->
  class extends Base
    model_name: 'side'
    
    constructor: ( options, @game )->
      super options

    get_name: ->
      return @name if @name
      return @power[0] if @power
      return 'Random'

    is_creator: ->
      @game.creator == @user
