class view.Chat extends view.Base
  constructor: ( game, messages )->
    super game, 'chat'

    @window = @find '.window'
    @form = @find 'form'

    @form.on 'ajax:success', ->  $(this).find('#message_text').val('')

    for message in messages.reverse()
      @add_message message

    @game.channel.bind 'message', ( message )=>
      @add_message message
      return


  update: ( game_updated )->
    return unless game_updated

    user_side = @game.user_side

    form_is_available =
      switch @game.status
        when 'waiting' then true
        when 'started' then user_side && user_side.alive
        when 'finished' then user_side

    if not form_is_available
      @form.hide()
      return

    if user_side && user_side.power && @private_channel == undefined
      @private_channel = @game.websockets.subscribe_private "#{@game.id}_#{user_side.power}"
      @private_channel.bind 'message', ( message )=>
        @add_message message
        return

    chat_is_private = @game.status == 'started' && @game.last.raw.date % 2 == 0

    @form.find('.field.message_to').toggle chat_is_private

    if chat_is_private
      select = @form.find 'select#message_to'
      select.empty()
      select.append '<option value></option>'
      for side in @game.raw.sides
        continue unless side.alive && side != @game.user_side
        power = side.power
        select.append "<option value=\"#{power}\">#{power}</option>"

    return


  add_message: ( message )->
    scroll = (@window[0].scrollHeight - @window.scrollTop()) <= @window.outerHeight() #innerHeight
    $("
      <div class='message #{if message.public then 'public' else 'private'}'>
        <div class='when'>#{@time_format(message.created_at)}</div>
        <div class='who'>#{@side_span(message.from)}</div>
        <div class='what'>#{message.text}</div>
      </div>
    ")
    .appendTo @window
    @window.scrollTop(@window[0].scrollHeight) if scroll
    return


  side_span: ( side )->
    "<span class='#{side}'>#{side}</span>"


  time_format: ( created_at )->
    (new Date(created_at)).toTimeString().replace(/^(\S+)\s+.+$/, "$1")
