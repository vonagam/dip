###* @jsx React.DOM ###



vr.Game = React.createClass
  state_from_data: ( data )->
    [state, states] = @states_from_data data

    data: data
    user_side: @user_side_from_data data
    states: states
    state: state.read_data()

  user_side_from_data: ( data )->
    for side in data.sides
      return side if side.user_side
    return null

  states_from_data: ( data )->
    if @state && data.states.length >= @state.states.length
      if data.states.length > @state.states.length
        @last.raw = data.states[ data.states.length - 2 ]
        @last.last = false

        @last = new g.model.State data.states[ data.states.length - 1 ]
        @last.last = true

        @state.states.push @last
      else
        @last.raw = data.states[ data.states.length - 1 ]

      state = @state.state
      states = @state.states
    else

      states = for state in data.states then new g.model.State state
      @last = states[states.length - 1]
      @last.last = true

      state = @last

    return [state, states]

  start_websockets: ->
    host = if window.location.host == 'localhost:3000' then 'localhost:3000' else 'ws://dip.kerweb.ru'
    @websockets = new WebSocketRails host + '/websocket'
    @game_channel = @websockets.subscribe @id
    @game_channel.bind 'state', @fetch
    @game_channel.bind 'side', @fetch

  listen_side_channel: ( side_name )->
    @side_channel?.destroy()

    if side_name
      @side_channel = @websockets.subscribe_private "#{@id}_#{side_name}"

    return

  fetch: ->
    $(@getDOMNode()).ajax 'get', Routes.game_path( @id, format: 'json' ), 
      {}
      ( data )=>
        @setState @state_from_data data
        return
    return

  set_state: ( state )->
    @setState state: state.read_data()
    return

  getInitialState: ->
    data = @props.initialData
    @id = data.id
    state = @state_from_data data

    @start_websockets()
    @listen_side_channel state.user_side?.name

    state

  componentWillUnmount: ->
    @websockets.destroy()
    @side_channel?.destroy()
    return

  componentDidUpdate: ( props, prev_state )->
    if @state.user_side?.name != prev_state.user_side?.name
      @listen_side_channel @state.user_side?.name
    return

  render: ->
    Menu = vr.Menu
    Map = vr.Map
    Chat = vr.Chat
    Orders = vr.Orders

    `<div id='games_show' className='page'>
      <Menu 
        game={this.state} 
        page={this} 
      />
      <Resizer>
        <Orders game={this.state}>
          <Map 
            game={this.state} 
            page={this}
            coords={maps.Standart} 
          />
        </Orders>
        <Chat 
          game={this.state} 
          initialMessages={this.props.initialMessages}
          side_channel={this.side_channel}
          game_channel={this.game_channel}
        />
      </Resizer>
    </div>`



Resizer = React.createClass
  getInitialState: ->
    dragging: false
    offset: 0
    percent: parseFloat( $.cookie 'percent' ) || 50
  onMouseDown: (e)->
    @setState dragging: true, offset: e.pageX - e.target.offsetLeft
    vr.stop_event e
    return
  onMouseUp: (e)->
    $.cookie 'percent', @state.percent
    @setState dragging: false, offset: 0
    vr.stop_event e
    return
  onMouseMove: (e)->
    first_left = @refs.leftPart.getDOMNode().offsetLeft

    mouse_left = e.pageX - @state.offset
    
    percent = ( mouse_left - first_left ) / $(@getDOMNode()).width() * 100

    percent = Math.min 70, Math.max 30, percent

    @setState percent: percent

    vr.stop_event e
    return
  componentDidUpdate: ( props, prev_state )->
    if @state.dragging != prev_state.dragging
      @toggle_listeners @state.dragging
    return
  componentWillUnmount: ->
    @toggle_listeners false
    return
  toggle_listeners: ( bool )->
    toggle = if bool then 'addEventListener' else 'removeEventListener'
    document[toggle] 'mousemove', @onMouseMove
    document[toggle] 'mouseup', @onMouseUp
  render: ->
    `<div className='pils2'>
      <div ref='leftPart' className='pil left' style={ { 'width': this.state.percent + '%' } }>
        { this.props.children[0] }
      </div>
      <div className='resizer' onMouseDown={ this.onMouseDown } />
      <div className='pil right' style={ { 'width': (100 - this.state.percent) + '%' } }>
        { this.props.children[1] }
      </div>
    </div>`
