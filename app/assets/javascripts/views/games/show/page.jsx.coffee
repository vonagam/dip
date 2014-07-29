###* @jsx React.DOM ###

modulejs.define 'v.g.s.Page',
  [
    'maps'
    'm.Game'
    'm.User'
    'v.g.s.Menu'
    'v.g.s.Map'
    'v.g.s.Info'
    'v.g.s.Chat'
    'v.g.s.map.Order'
    'v.g.s.Resizer'
    'WebSockets'
  ]
  ( maps, Game, User, Menu, Map, Info, Chat, Orders, Resizer, WebSockets )->

    React.createClass
      getInitialState: ->
        game: new Game @props.game, user: @props.user
        user: new User @props.user
        map_or_info: 'map'

      listenGameChannel: ->
        @game_channel = WebSockets.subscribe @state.game.id
        @game_channel.bind 'state', @fetch
        @game_channel.bind 'side', @fetch

      listenSideChannel: ( side_name )->
        channel_name = "#{@id}_#{side_name}"
        return if @side_channel && @side_channel.name == channel_name
        if @side_channel
          WebSockets.unsubscribe @side_channel.name
          @side_channel = null
        if side_name
          @side_channel = WebSockets.subscribe_private channel_name
        return

      fetch: ->
        $(@getDOMNode()).ajax 'get', Routes.game_path( @state.game.id, format: 'json' ), {},
          ( data )=>
            @setState game: @state.game.set data.game
            return
        return

      set_state: ( state )->
        @state.game.state = state.read_data()
        @setState game: @state.game
        return

      setMapOrInfo: ( bool )->
        @setState map_or_info: bool
        return

      componentWillMount: ->
        @listenGameChannel()
        @listenSideChannel @state.game.user_side?.name
        return

      componentWillUnmount: ->
        @websockets.disconnect()
        @side_channel?.destroy()
        return

      componentDidUpdate: ( props, prev_state )->
        if @state.game.user_side?.name != prev_state.game.user_side?.name
          @listenSideChannel @state.game.user_side?.name
        return

      componentDidMount: ->
        node = $(@getDOMNode()).parent()[0]
        callback = ->
          unless document.body.contains node
            $(document).off 'page:change', callback
            React.unmountComponentAtNode node
          return
        $(document).on 'page:change', callback
        return

      render: ->
        game = @state.game
        user = @state.user

        left_part = 
          if @state.map_or_info == 'map'
            `<Orders game={game}>
              <Map 
                game={game} 
                page={this}
                coords={maps.Standart} 
              />
            </Orders>`
          else
            `<Info game={game} />`

        `<div id='games_show' className='page'>
          <Menu 
            game={game}
            user={user} 
            page={this}
          />
          <Resizer>
            {left_part}
            <Chat 
              game={game}
              user={user}
              side_channel={this.side_channel}
              game_channel={this.game_channel}
            />
          </Resizer>
        </div>`
