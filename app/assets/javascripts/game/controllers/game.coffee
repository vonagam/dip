class controller.Game
  constructor: ( data )->
    @id = data.id
    @type = data._type

    host = if window.location.host == 'localhost:3000' then 'localhost:3000' else 'ws://dip.kerweb.ru'
    
    @websockets = new WebSocketRails host + '/websocket'
    @channel = @websockets.subscribe data.id

    @views = []
    new view.Chat this, data.messages
    new view.History this
    new view.Order this
    new view.Participation this
    new view.Timer this

    @update data

    @channel.bind 'state', => @fetch()
    @channel.bind 'side', => @fetch()


  update: ( data )->
    @raw_data = data
    @status = data.status
    @user_side = @get_user_side data.sides

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

    @update_views false
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
      return side if side.current
    return null


  fetch: ->
    g.page.ajax 'get', "/games/#{@id}.json", {}, (game_data)=>
      @update game_data
      return
    return
