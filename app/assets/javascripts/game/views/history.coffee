class view.History
  constructor: ( @game )->
    @view = g.page.find '.history.j_component'
    @select = @view.find 'select'
    @button = @view.find '.button'

    @select.on 'change', =>
      state = @find_state @select.val()
      @game.set_state state unless state.attached
      return

    @button.clicked ()=>
      @select.val @game.last.raw.id
      @game.set_state @game.last
      return

  update: ( select_options = false )->
    visible = @game.status != 'waiting'

    @view.toggle visible

    if visible
      if select_options
        @select.empty()
        for state in @game.states
          @select.prepend @state_option state

      @button.toggle !@game.state.last
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
