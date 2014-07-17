###* @jsx React.DOM ###

modulejs.define 'r.v.Games',
  ['r.v.games.Game', 'vr.input.Field']
  ( Game, Filters )->
    column_icons =
      status: 'lightbulb-o'
      sides: 'male'
      time_mode: 'clock-o'
      chat_mode: 'envelope-o'
      powers_is_random: 'flag'
      is_public: 'eye'
      is_participated: 'gamepad'
      created_at: 'calendar'

    React.createClass
      getInitialState: ->
        games: @props.games
      changeGames: ( games )->
        @setState games: games
        return
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
        for game in @state.games
          is_participated = 
            if @props.participated
              @props.participated.indexOf( game._id ) != -1
            else
              null

          games[game._id] = `<Game game={game} fields={this.state.fields} is_participated={is_participated} />`

        columns = {}
        for name, icon of column_icons
          columns[name] = 
            `<div className={name} title={I18n.t('games.index.columns.'+name)}>
              <i className={'fa fa-'+icon}/>
            </div>`

        `<div className='games container'>
          <div className='title'>{I18n.t("application.root.games.title")}</div>
          <Filters changeGames={this.changeGames} />
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
