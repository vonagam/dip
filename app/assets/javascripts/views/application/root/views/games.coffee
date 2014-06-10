class r.view.Games extends r.view.Base
  constructor: ( root )->
    super root, 'games', true
    @games = []
    @filter = {}
    @filters = @find '.filter'
    @tbody = @find '.tbody'
    @tfooter = @find '.tfooter'

    @find('.filters').on 'change', => @redraw()

    @view.clicked '.pag', (e)=>
      pag = $ e.target
      return if pag.hasClass 'current'
      pag.choosen 'current'
      tab = @tbody.children().eq parseInt(pag.html())-1
      tab.choosen 'current'
      return


  is_enable: ->
    true


  update: ( data )->
    super

    if @root.user
      for game in data.games
        if -1 < $.inArray game.id, @root.user.participated_games
          game.participated = true

    data.games.sort (a, b)->
      if a.participated != b.participated
        return if a.participated then -1 else 1

      if a.status != b.status
        return -1 if a.status == 'waiting'
        return 1 if a.status == 'finished'
        return -1 if b.status == 'finished'

      return 0

    @games = data.games

    @redraw()

    return


  redraw: ->
    @calculate_filter()

    @tbody.empty()
    @tfooter.empty()

    i = 0
    tab_i = 0

    for game in @games
      continue unless @match_filter game

      if i == 0
        i = 12
        tab_i++
        tab = $('<div class="tab"></div>').appendTo @tbody
        pag = $("<div class='pag'>#{tab_i}</div>").appendTo @tfooter
      else
        i++

      game_template.clone().html_hash
        time_mode: game.time_mode
        chat_mode: game.chat_mode
        sides: game.sides
        status: (x)-> x.addClass game.status
      .addClass if game.participated then 'participated' else null
      .attr href: game.url
      .appendTo tab

    if tab_i == 1
      @tfooter.empty()
    else
      @tfooter.children().eq(0).addClass 'current'
      
    @tbody.children().eq(0).addClass 'current'

    return


  calculate_filter: ->
    result = {}

    @filters.each ->
      f = $ this
      input = f.find '.input'
      return unless input.val()
      name = f.data 'filter'
      result[name] = input.val()
      return

    @filter = result
    return


  match_filter: ( game )->
    for field, val of @filter
      return false if game[field] != val
    return true


game_template = $("\
<a class='game tr'>\
<span class='td status'></span>\
<span class='td time_mode'></span>\
<span class='td chat_mode'></span>\
<span class='td sides'></span>\
</a>
")
