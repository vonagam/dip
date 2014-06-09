class view.Control extends view.Base
  constructor: ( game )->
    if game.user_side && game.user_side.creator
      super game, 'control'


  is_active: ->
    @game.status == 'waiting' 


  update: ( game_updated )->
    @update_status() if game_updated
    return
