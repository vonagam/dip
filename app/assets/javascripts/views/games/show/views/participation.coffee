class g.view.Participation extends g.view.Base
  constructor: ( game )->
    super game, 'participation'


  is_active: ->
    @game.status == 'waiting' && @game.user_side == null


  update: ( game_updated )->
    @update_status() if game_updated
    return
