class g.view.OldOrder extends g.view.Base
  constructor: ( game )->
    super game, 'old_order'


  is_active: ->
    !@game.state.last || @game.status == 'finished'


  update: ( game_updated )->
    return if game_updated

    @update_status()

    g.game_phase.Looking.turn true if @turned

    return
