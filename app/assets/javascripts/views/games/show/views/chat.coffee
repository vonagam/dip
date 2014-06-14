class g.view.Chat extends g.view.Base
  constructor: ( game )->
    super game, 'chat', true

    @all = false
    @private = false
    @offset = null

    @window = @find '.window'
    @form = @find 'form'
    @select = @form.find '.message_to > .input'
    @textarea = @form.find '.message_text > .input'

    @form.on 'ajax:success', =>  @textarea.val ''

    @game.channel.bind 'message', ( message )=>
      @add_new_message message
      return

    @toggle_keybindings = new state.Base
      toggls:
        keys:
          target: doc
          bind:
            keydown: (e)=>
              if e.shiftKey && @textarea.is(':focus')
                @form.submit() if e.which == 13
                @move_select_value 'prev' if e.which == 38
                @move_select_value 'next' if e.which == 40
              return

    @window.on 'scroll', (e)=>
      @fetch() if @window.scrollTop() < 20
      return


  fetch: ->
    return if @all

    @window.ajax 'get', 
      "/games/#{@game.id}/messages" 
      offset: @offset
      ( messages )=>
        @fill messages
        return
    
    return


  fill: ( messages )->
    @add_olg_messages messages

    @offset = messages[ messages.length - 1 ].created_at if messages.length > 0
    @all = true if messages.length < 100

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
          @add_new_message message
          return
    else
      @private = false

    @toggle_keybindings.turn form_is_available

    chat_is_private = @game.status == 'started' && !@game.raw_data.chat_is_public

    @form.find('.field.message_to').toggle chat_is_private

    if chat_is_private
      @select.empty()

      def_option = if @game.raw_data.chat_mode == 'both' then 'Public' else ''
      @select.append @side_option def_option
      
      for side in @game.raw_data.sides
        continue unless side.alive && side != @user_side
        @select.append @side_option side.power

    return


  add_olg_messages: ( messages )->
    scroll_top = @window.scrollTop()
    inner_height = @window[0].scrollHeight

    @add_message message, 'prepend' for message in messages
    
    @window.scrollTop scroll_top + @window[0].scrollHeight - inner_height
    return


  add_new_message: ( message )->
    scroll = (@window[0].scrollHeight - @window.scrollTop()) <= @window.outerHeight()
    @add_message message, 'append'
    @window.scrollTop @window[0].scrollHeight if scroll
    return



  add_message: ( message, method )->
    @window[method](
      message_template.clone().html_hash
        created_at: @time_format message.created_at
        from: @side_span message.from
        to: @side_span message.to
        text: message.text
      .addClass if message.is_public then 'public' else 'private'
    )
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
