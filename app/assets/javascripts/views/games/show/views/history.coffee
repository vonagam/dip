class g.view.History extends g.view.Base
  constructor: ( game )->
    super game, 'history'

    @select = @find 'select'
    @controls = @find '.controls'

    presses_info =
      '.back.all': (x)-> 0
      '.back.one': (x)-> x-1
      '.forward.one': (x)-> x+1
      '.forward.all': (x)-> game.states.indexOf game.last

    create_listener = ( listener )=>
      (e)=>
        return if $(e.target).closest('.control').is('.hidden')
        state = @game.states[ listener @game.states.indexOf @game.state ]
        @select.val state.raw.id
        @game.set_state state
        return false

    for selector, listener of presses_info
      @controls.find(selector).clicked create_listener listener
    @controls.clicked -> false

    @select.on 'change', =>
      state = @find_state @select.val()
      @game.set_state state unless state.attached
      return

    @toggls.doc =
      target: doc
      bind:
        keydown: (e)=>
          if e.shiftKey
            @controls.find('.back.one').trigger 'mousedown' if e.which == 37
            @controls.find('.forward.one').trigger 'mousedown' if e.which == 39
          return


  is_active: ->
    @game.status != 'waiting'


  update: ( game_updated )->
    @update_status()

    if @turned
      @fill_select_options() if game_updated

      @controls.find('.back').toggleClass 'hidden', @game.state.raw.date == 0
      @controls.find('.forward').toggleClass 'hidden', @game.state.last
    
    return


  fill_select_options: ->
    @select.empty()
    @select.prepend @state_option state for state in @game.states
    return


  state_option: ( state )->
    value = state.raw.id
    selected = if state.attached then 'selected="true"' else ''
    year = parseInt state.raw.date / 2
    season = state.raw.date % 2
    text = "#{year}.#{season}:#{state.type()}"
    "<option value=\"#{ value }\" #{ selected }>#{ text }</option>"


  find_state: ( id )->
    for state in @game.states
      return state if state.raw.id == id
    return undefined


  find_state_by_date: ( date )->
    for state in @game.states
      return state if state.raw.date == date
    return undefined
