class view.Stats extends view.Base
  constructor: ( game )->
    super game, 'stats', true
    @body = @find 'tbody'
    @tr = $ '<tr><td class="power"></td><td class="supplies"></td><td class="units"></td></tr>'


  update: ( game_updated )->
    return if game_updated

    @body.empty()

    for name, power of @game.state.powers
      ptr = @tr.clone()
      ptr.addClass name
      ptr.children('.power').html name
      ptr.children('.units').html power.units.length
      ptr.children('.supplies').html power.supplies().length
      ptr.appendTo @body

    return
