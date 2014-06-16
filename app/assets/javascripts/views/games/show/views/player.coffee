class g.view.Player extends g.view.Base
  constructor: ( game )->
    super game, 'player'

    @login = @find '.login'
    @power = @find '.power'


  is_active: ->
    @game.raw_data.login != undefined


  update: ( game_updated )->
    return unless game_updated

    @update_status()

    if @turned
      @login.html @game.raw_data.login

      side = @game.user_side
      @power.toggle side != null
      @power.html side.name || 'Random' if side

      @view.toggleClass 'two_line', side != null

    return
