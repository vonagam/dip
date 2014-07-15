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
          is_participated = 
            if @props.participated
              @props.participated.indexOf( game._id ) != -1
            else
              null

          games[game._id] = `<Game game={game} fields={this.state.fields} is_participated={is_participated} />`

        filters = {}
        for name, field_props of schema
          callback = this.onChange.bind null, name
          field = Field $.extend { label: name, onChange: callback }, field_props
          filters[name] = `<div className='td'>{field}</div>`

        `<div className='games container'>
          <div className='title'>{I18n.t("application.root.games.title")}</div>
          <div className='filters'>{filters}</div>
          <div className='table'>
            <div className='thead tr'>
              <div className='name'>Name</div> 
              <div className='status'><i className='fa fa-lightbulb-o'/></div>
              <div className='sides'><i className='fa fa-male'/></div>
              <div className='time_mode'><i className='fa fa-clock-o'/></div>
              <div className='chat_mode'><i className='fa fa-envelope-o'/></div>
              <div className='powers_is_random'><i className='fa fa-flag'/></div>
              <div className='is_public'><i className='fa fa-eye'/></div>
              <div className='is_participated'><i className='fa fa-gamepad'/></div>
              <div className='created_at'><i className='fa fa-calendar'/></div>
            </div>
            <div className='tbody'>
              {games}
            </div>
          </div>
        </div>`
