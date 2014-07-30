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
        game: new Game @props.game, new User @props.user
        map_or_info: 'map'

      listenGameChannel: ->
        @game_channel = WebSockets.subscribe @state.game.id
        @game_channel.bind 'side', @setSides
        @game_channel.bind 'game', @setGame

      listenSideChannel: ->
        side_name = @state.game.user_side?.name
        channel_name = "#{@id}_#{side_name}"
        return if @side_channel && @side_channel.name == channel_name
        if @side_channel
          WebSockets.unsubscribe @side_channel.name
          @side_channel = null
        if side_name
          @side_channel = WebSockets.subscribe_private channel_name
        return

      updateGame: ( options )->
        @setState game: @state.game.$update options
        return

      setGame: ( data )->
        @updateGame $merge: JSON.parse(data).game
        return

      setSides: ( data )->
        @updateGame sides: $set: JSON.parse(data).sides
        return

      setGameState: ( state )->
        @updateGame state: $set: state
        return

      fetch: ->
        $(@getDOMNode()).ajax 'get', Routes.game_path( @state.game.id, format: 'json' ), {},
          ( data )=>
            @updateGame $merge: data.game
            return
        return

      setMapOrInfo: ( bool )->
        @setState map_or_info: bool
        return

      componentWillMount: ->
        @listenGameChannel()
        @listenSideChannel()
        return

      componentWillUnmount: ->
        WebSockets.unsubscribe @game_channel.name
        WebSockets.unsubscribe @side_channel.name if @side_channel
        return

      componentDidUpdate: ->
        @listenSideChannel()
        return

      componentWillUpdate: ( next_props, next_state )->
        next_state.game.state.read_data()
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
            page={this}
          />
          <Resizer>
            {left_part}
            <Chat 
              game={game}
              side_channel={this.side_channel}
              game_channel={this.game_channel}
            />
          </Resizer>
        </div>`
