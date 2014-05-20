@game_chat = -> 
  chat = $ '#chat'

  $('#new_message').on 'ajax:success', -> $(this).find('#message_text').val('')

  chat.on 'resize', ->
    log 1

  dispatcher = new WebSocketRails 'localhost:3000/websocket'

  game_id = chat.data 'game'
  side = chat.data 'side'

  chat.ajax 'get', "/games/#{game_id}/messages.json", {}, (response)->
    for message in response.reverse()
      add_message chat, message

  channel_public = dispatcher.subscribe game_id

  channel_public.bind 'message', (message)->
    add_message chat, message
    return

  if side
    channel_private = dispatcher.subscribe_private "#{game_id}_#{side}"

    channel_private.bind 'message', (message)->
      add_message chat, message
      return

side_span = ( side )->
  "<span class='#{side}'>#{side}</span>"

time_format = ( created_at )->
  (new Date(created_at)).toTimeString().replace(/^(\S+)\s+.+$/, "$1")

add_message = ( chat, message ) ->
  scroll = (chat[0].scrollHeight - chat.scrollTop()) <= chat.outerHeight() #innerHeight

  $("
    <div class='message #{if message.public then 'public' else 'private'}'>
      <div class='when'>#{time_format(message.created_at)}</div>
      <div class='who'>#{side_span(message.from)}</div>
      <div class='what'>#{message.text}</div>
    </div>
  ")
  .appendTo chat

  chat.scrollTop(chat[0].scrollHeight) if scroll
