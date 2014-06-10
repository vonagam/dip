class r.view.NewGame extends r.view.Base
  constructor: ( root )->
    super root, 'new_game'

  is_enable: ->
    @root.user != undefined
