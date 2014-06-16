class g.controller.Game extends BP.Controller
  constructor: ( page_arguments )->
    data = page_arguments[0]
    messages = page_arguments[1]
    @regions = page_arguments[2]
    window.regions = @regions

    super g, "/games/#{data.id}.json"

    @id = data.id
    @type = data._type

    g.map.find('[data-coords]').each ->
      q = $ this
      xy = q.attr('data-coords').split(',')
      q.data 'coords', new Vector({ x: parseInt(xy[0]), y: parseInt(xy[1]) })

    host = if window.location.host == 'localhost:3000' then 'localhost:3000' else 'ws://dip.kerweb.ru'
    @websockets = new WebSocketRails host + '/websocket'
    @channel = @websockets.subscribe data.id
    @channel.bind 'state', => @fetch()
    @channel.bind 'side', => @fetch()
    @side_channel = null

    @user_side = @get_user_side data.sides

    @add_views data
    new g.view._Actions @views

    @update data
    
    @views.chat.fill messages


  update: ( data )->
    @raw_data = data
    @status = data.status
    @user_side = @get_user_side data.sides

    if @user_side
      if @side_channel == null
        @side_channel = @websockets.subscribe_private "#{@id}_#{@user_side.name}"
    else
      if @side_channel != null
        @side_channel.destroy()
        @side_channel = null

    if @states && data.states.length >= @states.length
      if data.states.length > @states.length
        @last.raw = data.states[ data.states.length - 2 ]
        @last.last = false

        @last = new g.model.State data.states[ data.states.length - 1 ], this
        @last.last = true

        @states.push @last
      else
        @last.raw = data.states[ data.states.length - 1 ]

      @set_state @state

    else
      @states = for state in data.states then new g.model.State state, this
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


  get_user_side: ( sides )->
    for side in sides
      return side if side.user_side
    return null


  is_left: ->
    return false if @raw_data.time_mode == 'manual' || @states.length < 4
    @last.raw.end_at == null



  toggle_webscokets: ( bool )->
    if bool
      @websockets.reconnect()
    else
      @websockets.disconnect()
    return


  page_stashed: ->
    super
    @toggle_webscokets false
    return


  page_restored: ->
    window.regions = @regions
    super
    @toggle_webscokets true
    @fetch()
    return
