class g.view.Start extends g.view.Base
  constructor: ( game )->
    if game.user_side && game.user_side.creator
      super game, 'start'

      #@view.on 'ajax:success', ( e, data )=>
      #  @game.update data
      #  return false


  is_active: ->
    @game.status == 'waiting' 


  update: ( game_updated )->
    @update_status() if game_updated
    return
