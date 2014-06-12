class g.view.Stats extends g.view.Base
  constructor: ( game )->
    super game, 'stats', true
    @body = @find 'tbody'
    @tr = $ '<tr><td class="power"></td><td class="supplies"></td><td class="units"></td></tr>'


  update: ( game_updated )->
    return if game_updated

    @body.empty()

    for name, power of @game.state.powers
      @tr.clone()
      .addClass name
      .html_hash
        power: name
        units: power.units.length
        supplies: power.supplies().length
      .appendTo @body

    return
