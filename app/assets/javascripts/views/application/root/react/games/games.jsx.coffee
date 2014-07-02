###* @jsx React.DOM ###

modulejs.define 'r.v.Games',
  ['r.v.games.Game', 'vr.input.Field']
  ( Game, Field )->
    schema =
      status: collection: ['waiting','going','ended']
      sides: sub_type: 'number'
      creator: {}
      created_at: {}
      chat_mode: collection: [1,2,3]
      time_mode: collection: [1,2,3]


    React.createClass
      getInitialState: ->
        state = fields: {}
        for field of schema
          state.fields[field] = null
        state
      setFilter: ( field, filter )->
        fields = @state.fields
        fields[field] = filter
        @setState fields: fields
        return
      onChange: (name, e)->
        #TODO fired two times? why?
        field = name
        filter = e.target.value
        filter = if filter then new RegExp filter, 'i' else null
        @setFilter field, filter
        return
      render: ->
        games = {}
        for game in @props.games
          games[game._id] = `<Game game={game} fields={this.state.fields} />`

        heads = {}
        for name, field_props of schema
          callback = this.onChange.bind null, name
          field = Field $.extend { label: name, onChange: callback }, field_props
          heads[name] = `<div className='td'>{field}</div>`

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
