class g.view.Rollback extends g.view.Base
  constructor: ( game )->
    if game.user_side && game.user_side.creator
      super game, 'rollback'

      @view.on 'ajax:success', ( e, data )=>
        @game.update data
        return false


  is_active: ->
    @game.status == 'going' && 
    @game.states.length > 1 && 
    @game.raw_data.sides.length == 1 


  update: ( game_updated )->
    @update_status() if game_updated
    return
