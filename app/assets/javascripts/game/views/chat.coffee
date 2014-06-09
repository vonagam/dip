class view.Chat extends view.Base
  constructor: ( game, data )->
    super game, 'chat', true

    @window = @find '.window'
    @form = @find 'form'

    @form.on 'ajax:success', ->  $(this).find('#message_text').val('')

    for message in data.messages.reverse()
      @add_message message

    @game.channel.bind 'message', ( message )=>
      @add_message message
      return

    @private = false


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

    if @game.side_channel
      unless @private
        @private = true
        @game.side_channel.bind 'message', ( message )=>
          @add_message message
          return
    else
      @private = false

    chat_is_private = @game.status == 'started' && !@game.raw_data.chat_is_public

    @form.find('.field.message_to').toggle chat_is_private

    if chat_is_private
      select = @form.find 'select#message_to'
      select.empty()

      def_option = if @game.raw_data.chat_mode == 'both' then 'Public' else ''
      select.append @side_option def_option
      
      for side in @game.raw_data.sides
        continue unless side.alive && side != @game.user_side
        select.append @side_option side.power

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
  side_option: ( side )->
    "<option value='#{side}'>#{side}</option>"


  time_format: ( created_at )->
    (new Date(created_at)).toTimeString().replace(/^(\S+)\s+.+$/, "$1")
