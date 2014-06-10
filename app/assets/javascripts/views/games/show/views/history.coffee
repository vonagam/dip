class g.view.History extends g.view.Base
  constructor: ( game )->
    super game, 'history'

    @select = @find 'select'
    @button = @find '.button'

    @select.on 'change', =>
      state = @find_state @select.val()
      @game.set_state state unless state.attached
      return

    @button.clicked ()=>
      log 1
      @select.val @game.last.raw.id
      @game.set_state @game.last
      return


  is_active: ->
    @game.status != 'waiting'


  update: ( game_updated )->
    @update_status()

    if @turned
      @fill_select_options() if game_updated
      @button.toggle !@game.state.last
    
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
