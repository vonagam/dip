class controller.Game
  constructor: ( data )->
    @id = data.id
    @type = data._type

    host = if window.location.host == 'localhost:3000' then 'localhost:3000' else 'ws://dip.kerweb.ru'
    @websockets = new WebSocketRails host + '/websocket'
    @channel = @websockets.subscribe data.id
    @channel.bind 'state', => @fetch()
    @channel.bind 'side', => @fetch()
    @side_channel = null

    @user_side = @get_user_side data.sides

    @views = []
    for view_component in [
      'Chat', 'Stats'
      'Control', 'Participation'
      'History', 'Order'
      'Manual', 'Timer'
    ]
      new view[view_component] this, data

    @update data


  update: ( data )->
    @raw_data = data
    @status = data.status
    @user_side = @get_user_side data.sides

    if @user_side
      if @side_channel == null
        @side_channel = @websockets.subscribe_private "#{@id}_#{@user_side.power}"
    else
      if @side_channel != null
        @side_channel.destroy()
        @side_channel = null

    if @states
      if data.states.length > @states.length
        @last.raw = data.states[ data.states.length - 2 ]
        @last.last = false

        @last = new model.State data.states[ data.states.length - 1 ], this
        @last.last = true

        @states.push @last
      else
        @last.raw = data.states[ data.states.length - 1 ]

      @set_state @state

    else
      @states = for state in data.states then new model.State state, this
      @last = @states[@states.length - 1]
      @last.last = true
      @set_state @last

    @update_views true
    return


  set_state: ( state )->
    @state.detach() if @state
    @state = state
    @state.attach() if @state

    g.state = @state

    @update_views false
    return


  update_views: ( game_updated )->
    view.update game_updated for view in @views
    return


  get_user_side: ( sides )->
    for side in sides
      return side if side.user_side
    return null


  fetch: ->
    g.page.ajax 'get', "/games/#{@id}.json", {}, (game_data)=>
      @update game_data
      return
    return


  toggle_webscokets: ( bool )->
    if bool
      @websockets.reconnect()
    else
      @websockets.disconnect()
    return
