class g.view.Delete extends g.view.Base
  constructor: ( game )->
    if game.user_side && game.user_side.creator
      super game, 'delete'


  is_active: ->
    @game.status == 'waiting' || 
    @game.raw_data.time_mode == 'manual' || 
    @game.is_left()


  update: ( game_updated )->
    @update_status() if game_updated
    return
