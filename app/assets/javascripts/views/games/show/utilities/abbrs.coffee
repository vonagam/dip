g.utility.toggle_abbrs = ->
  map = $ '#diplomacy_map'
  button = $ '#games_show .abbrs'

  button.clicked ->
    button.toggleClass 'hidden'
    map.attr 'data-hide-abbrs', button.hasClass('hidden')
    return
