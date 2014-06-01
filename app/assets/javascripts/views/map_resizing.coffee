@map_resizing = ->
  container = $ '#games_show > .pils2'
  resizer = container.children '.resizer'
  pils = container.children '.pil'
  first = pils.eq 0
  second = pils.eq 1
  offset = 0

  toggle = (on_off)->
    doc[on_off] 
      'mousemove': mousemove
      'mouseup': mouseup

  mouseup = ->
    toggle 'off'

  resizer.on 'mousedown', (e)->
    offset = e.pageX - resizer.offset().left
    toggle 'on'
    return false

  mousemove = (e)->
    first_left = first.offset().left
    mouse_left = e.pageX - offset
    
    first_percent = ( mouse_left - first_left ) / container.width() * 100

    if first_percent < 30
      first_percent = 30
    else if first_percent > 70
      first_percent = 70

    first.css width: first_percent + '%'
    second.css width: (100 - first_percent) + '%'
