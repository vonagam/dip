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
  ]
  ( maps, Game, User, Menu, Map, Info, Chat, Orders, Resizer )->

    React.createClass
      getInitialState: ->
        game: new Game @props.game, user: @props.user
        user: new User @props.user
        map_or_info: 'map'

      startWebsockets: ->
        host = if window.location.host == 'localhost:3000' then 'localhost:3000' else 'ws://dip.kerweb.ru'
        @websockets = new WebSocketRails host + '/websocket'
        @game_channel = @websockets.subscribe @state.game.id
        @game_channel.bind 'state', @fetch
        @game_channel.bind 'side', @fetch

      listenSideChannel: ( side_name )->
        @side_channel?.destroy()
        @side_channel = @websockets.subscribe_private "#{@id}_#{side_name}" if side_name
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

      componentWillUnmount: ->
        @websockets.disconnect()
        @side_channel?.destroy()
        return

      componentDidUpdate: ( props, prev_state )->
        if @state.game.user_side?.name != prev_state.game.user_side?.name
          @listenSideChannel @state.game.user_side?.name
        return

      componentWillMount: ->
        @startWebsockets()
        @listenSideChannel @state.game.user_side?.name
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
