class g.view.Chat extends g.view.Base
  constructor: ( game )->
    super game, 'chat', true

    @window = @find '.window'
    @form = @find 'form'
    @select = @form.find '.message_to > .input'
    @textarea = @form.find '.message_text > .input'

    @form.on 'ajax:success', =>  @textarea.val ''

    @game.channel.bind 'message', ( message )=>
      @add_message message
      return

    @private = false

    @keybindings = (e)=>
      if e.shiftKey && @textarea.is(':focus')
        @form.submit() if e.which == 13
        @move_select_value 'prev' if e.which == 38
        @move_select_value 'next' if e.which == 40
      return


  fill: ( messages )->
    @window.empty()
    @add_message message for message in messages.reverse()
    return


  update: ( game_updated )->
    return unless game_updated

    @user_side = @game.user_side

    form_is_available =
      switch @game.status
        when 'waiting' then true
        when 'started' then @user_side && @user_side.alive
        when 'finished' then @user_side

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

    doc[if chat_is_private then 'on' else 'off'] 'keydown', @keybindings

    if chat_is_private
      @select.empty()

      def_option = if @game.raw_data.chat_mode == 'both' then 'Public' else ''
      @select.append @side_option def_option
      
      for side in @game.raw_data.sides
        continue unless side.alive && side != @user_side
        @select.append @side_option side.power

    return


  add_message: ( message )->
    scroll = (@window[0].scrollHeight - @window.scrollTop()) <= @window.outerHeight() #innerHeight

    message_template.clone().html_hash
      created_at: @time_format message.created_at
      from: @side_span message.from
      to: @side_span message.to
      text: message.text
    .addClass if message.is_public then 'public' else 'private'
    .appendTo @window

    @window.scrollTop @window[0].scrollHeight if scroll
    return


  side_span: ( side )->
    "<span class='side #{side} #{side == @user_side.power}'>#{side}</span>"
  side_option: ( side )->
    "<option value='#{side}'>#{side}</option>"


  time_format: ( created_at )->
    (new Date(created_at)).toTimeString().replace(/^(\S+)\s+.+$/, "$1")


  move_select_value: ( method )->
    options = @select.children()
    if options.length > 1
      selected = options.filter ':selected'
      move_to = selected[ method ]()
      @select.val move_to.val() if move_to.length > 0
    return


message_template = $("
<div class='message'>
<div class='created_at'></div>
<div class='from'></div>
<div class='to'></div>
<div class='text'></div>
</div>
")
