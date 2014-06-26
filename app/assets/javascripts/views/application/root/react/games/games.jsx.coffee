###* @jsx React.DOM ###

modulejs.define 'r.v.Games',
  ['r.v.games.Game']
  ( Game )->
    React.createClass
      getInitialState: ->
        fields:
          status: null
          created_at: null
          sides: null
          is_public: null
          chat_mode: null
          time_mode: null
          creator: null
      setFilter: ( key, value )->
        fields = @state.fields
        fields[key] = value
        @setState fields: fields
        return
      render: ->
        games = {}
        for game in @props.games
          games[game._id] = `<Game game={game} fields={this.state.fields} />`

        heads = {}
        for name, filter of @state.fields
          heads[name] = `<div className='td'>{name}</div>`

        `<div className='games container'>
          <div className='table'>
            <div className='thead'>
              {heads}
            </div>
            <div className='tbody'>
              {games}
            </div>
          </div>
        </div>`
