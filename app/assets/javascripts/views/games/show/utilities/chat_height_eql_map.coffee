g.utility.chat_height_eql_map = ->
  left = g.page.find '> .pils2 > .left'
  right = g.page.find '> .pils2 > .right'

  difference = left.height() - right.height()

  if difference > 0

    chat_window = g.page.find '.chat .window'

    chat_window.height chat_window.height() + difference

  return
