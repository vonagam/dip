###* @jsx React.DOM ###

modulejs.define 'r.v.Games',
  ['r.v.games.Game', 'r.v.Filters']
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

    columns = {}
    columns['name'] = `<div className='name'>{I18n.t('games.index.columns.name')}</div>`
    for name, icon of column_icons
      columns[name] = 
        `<div className={name} title={I18n.t('games.index.columns.'+name)}>
          <i className={'fa fa-'+icon}/>
        </div>`

    React.createClass
      getInitialState: ->
        data: @props.data
      fetchData: ->
        $(@getDOMNode()).ajax 'get', 
          Routes.games_path(format: 'json'), 
          { filters: @refs.filters.state, page: 1 },
          ( data )=>
            @setState data: data
            return
        return
      render: ->
        data = @state.data

        games = {}
        for game in data.games
          is_participated = 
            if data.participated
              data.participated.indexOf( game._id ) != -1
            else
              null

          games[game._id] = `<Game game={game} is_participated={is_participated} />`

        `<div className='games container'>
          <div className='title'>{I18n.t("application.root.games.title")}</div>
          <Filters ref='filters' fetch={this.fetchData} />
          <div className='table'>
            <div className='thead tr'>{columns}</div>
            <div className='tbody'>{games}</div>
            <div className='tfoot'>{data.pages}</div>
          </div>
        </div>`
