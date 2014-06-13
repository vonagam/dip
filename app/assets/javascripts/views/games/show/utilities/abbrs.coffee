g.utility.toggle_abbrs = ->
  map = $ '#diplomacy_map'
  button = $ '#games_show .abbrs'

  abbrs_cookie = 'abbrs_visibility'

  button.clicked ->
    set_abbrs_visibility ! button.hasClass 'hidden'
    return

  set_abbrs_visibility = ( bool )->
    button.toggleClass 'hidden', bool
    map.attr 'data-hide-abbrs', bool
    $.cookie abbrs_cookie, bool
    return

  if b = $.cookie abbrs_cookie
    set_abbrs_visibility b == 'true'
    return

  return
