class g.view.History extends g.view.Base
  constructor: ( game )->
    super game, 'history'

    @select = @find 'select'
    @controls = @find '.controls'

    presses_info =
      back_all: [ '.back.all', (x)->0 ]
      back_one: [ '.back.one', (x)->x-1 ]
      forward_one: [ '.forward.one', (x)->x+1 ]
      forward_all: [ '.forward.all', (x)->game.last.raw.date ]

    for press_info in presses_info
      press = @controls.find press_info[0]
      press.clicked ()=>
        state = @find_state_by_date press_info[1] @game.state.raw.date
        @game.set_state state
        return


    @select.on 'change', =>
      state = @find_state @select.val()
      @game.set_state state unless state.attached
      return

    @controls.clicked '.control', (e)=>

    ###
    @button.clicked ()=>
      @select.val @game.last.raw.id
      @game.set_state @game.last
      return
    ###


  is_active: ->
    @game.status != 'waiting'


  update: ( game_updated )->
    @update_status()

    if @turned
      @fill_select_options() if game_updated
      #@button.toggle !@game.state.last
    
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
