@game_chat = -> 
  chat = $ '#chat'

  dispatcher = new WebSocketRails 'localhost:3000/websocket'

  game_id = chat.data 'game'
  side = chat.data 'side'

  chat.ajax 'get', "/games/#{game_id}/messages.json", {}, (response)->
    for message in response
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

sides_spans = ( array_of_sides )->
  r = []
  r.push "<span class='#{side}'>#{side}</span>" for side in array_of_sides
  r

add_message = ( chat, message ) ->
  log message
  $("
    <div class='message #{if message.public then 'public' else 'private'}'>
      <div class='time'>#{message.created_at}</div>
      <div class='from'>#{sides_spans([message.from])[0]}</div>
      <div class='to'>#{sides_spans(message.to).join()}</div>
      <div class='text'>#{message.text}</div>
    </div>
  ").appendTo chat
