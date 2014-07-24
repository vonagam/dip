###* @jsx React.DOM ###

modulejs.define 'r.v.Games',
  ['r.v.games.Game', 'r.v.Filters', 'icons']
  ( Game, Filters, icons )->
    fields = [
      'name'
      'status'
      'sides_count'
      'time_mode'
      'chat_mode'
      'powers_is_random'
      'is_public'
      'is_participated'
      'created_at'
    ]

    columns = for field in fields
      name = I18n.t 'games.index.columns.'+field
      if icon = icons.Game.fields[field]
        `<div key={field} className={field} title={name}>{icons.get(icon)}</div>`
      else
        `<div key={field} className={field}>{name}</div>`

    React.createClass
      getInitialState: ->
        @dataFromPrors @props.data
      dataFromPrors: (props)->
        games: props.games
        page: props.page
        pages: props.pages
      fetchData: ->
        $(@getDOMNode()).ajax 'get', 
          Routes.games_path(format: 'json'), 
          { filters: @refs.filters.state, page: 1 },
          (data)=>
            @setState @dataFromPrors data
            return
        return
      refresh: (props)->
        @setState @dataFromPrors props
        return
      render: ->
        games = for game in @state.games
          `<Game key={game.id} game={game} fields={fields} />`

        `<div className='games container'>
          <div className='title'>{I18n.t("application.root.games.title")}</div>
          <Filters ref='filters' fetch={this.fetchData} />
          <div className='table'>
            <div className='thead tr'>{columns}</div>
            <div className='tbody'>{games}</div>
            <div className='tfoot'>{this.state.pages}</div>
          </div>
        </div>`
