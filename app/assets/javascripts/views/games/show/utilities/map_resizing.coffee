g.utility.map_resizing = ->
  container = $ '#games_show > .pils2'
  resizer = container.children '.resizer'
  pils = container.children '.pil'
  first = pils.eq 0
  second = pils.eq 1
  offset = 0
  percent = 50

  map_size_cookie = 'map_size'

  toggle = (on_off)->
    doc[on_off] 
      'mousemove': mousemove
      'mouseup': mouseup

  mouseup = ->
    toggle 'off'
    $.cookie map_size_cookie, percent
    return

  resizer.on 'mousedown', (e)->
    offset = e.pageX - resizer.offset().left
    toggle 'on'
    return false

  apply_percent = ->
    if percent < 30
      percent = 30
    else if percent > 70
      percent = 70

    first.css width: percent + '%'
    second.css width: (100 - percent) + '%'

  mousemove = (e)->
    first_left = first.offset().left
    mouse_left = e.pageX - offset
    
    percent = ( mouse_left - first_left ) / container.width() * 100

    apply_percent() 
    return

  if p = $.cookie map_size_cookie
    percent = parseFloat p
    apply_percent() 

  return
