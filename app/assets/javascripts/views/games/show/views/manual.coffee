class g.view.Manual extends g.view.Base
  constructor: ( game, data )->
    if data.time_mode == 'manual' && game.user_side && game.user_side.creator
      super game, 'manual'


  is_active: ->
    @game.status == 'started' 


  update: ( game_updated )->
    @update_status() if game_updated
    return
