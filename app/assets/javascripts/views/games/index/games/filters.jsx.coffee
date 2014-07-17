###* @jsx React.DOM ###

modulejs.define 'r.v.Filters',
  ['vr.input.Field']
  ( Field )->
    schema =
      status: collection: I18n.t 'const.game.statuses'
      sides: sub_type: 'number'
      creator: {}
      created_at: {}
      chat_mode: collection: I18n.t 'const.game.chat_modes'
      time_mode: collection: I18n.t 'const.game.time_modes'

    React.createClass
      getInitialState: ->
        state = {}
        state[field] = null for field of schema
        state
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

        columns = {}
        for name, icon of column_icons
          columns[name] = 
            `<div className={name} title={I18n.t('games.index.columns.'+name)}>
              <i className={'fa fa-'+icon}/>
            </div>`

        `<div className='games container'>
          <div className='title'>{I18n.t("application.root.games.title")}</div>
          <div className='filters'>{filters}</div>
          <div className='table'>
            <div className='thead tr'>
              <div className='name'>{I18n.t('games.index.columns.name')}</div>
              {columns}
            </div>
            <div className='tbody'>
              {games}
            </div>
          </div>
        </div>`
