###
class g.view.Participation extends g.view.Base
  constructor: ( game, data )->
    unless game.user_side && game.user_side.creator
      super game, 'participation'

      @participate = @find '> .button.green'
      @change = @find '> .button.yellow'
      @cancel = @find '> .button.red'
      @popup = @find '> .new_side'

      @popup.hide()
      @popup.appendTo doc.find '#main.layout'

      @thinked = false

      @view.add( @popup ).on 'ajax:success', =>
        @thinked = false
        return

      @participate.add( @change ).clicked (e)=>
        @popup.fadeIn 500
        @show_popup $ e.target

      @popup.clicked (e)=>
        q = $ e.target
        if q[0] == @popup[0] || q.is '.closer'
          @popup.fadeOut 500
        return

      @popup.on 'ajax:success', =>
        @popup.fadeOut 500
        return

      if data.powers_is_random
        @change.remove()
        @popup.find('.field.side_power').remove()
      else
        @popup.find('.field.powers_is_random').remove()


  is_active: ->
    @game.status == 'waiting'


  update: ( game_updated )->
    return unless game_updated

    @update_status()

    @rethink() if @turned && !@thinked

    return


  rethink: ->
    @thinked = true

    @popup.hide()

    already = @game.user_side != null

    @participate.toggle !already
    @change.toggle already && !@game.raw_data.powers_is_random
    @cancel.toggle already

    return


  show_popup: ( button )->
    @popup.find '.button'
    .html button.html()
    .attr class: button.attr 'class'

    unless @game.raw_data.powers_is_random
      select = @popup.find '.side_power > select'
      select.children('[disabled]').prop 'disabled', false

      for side in @game.raw_data.sides
        continue unless side.power
        select.children( "[value='#{side.power[0]}']" ).prop 'disabled', true

    return
###
