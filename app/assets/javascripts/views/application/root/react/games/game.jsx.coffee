###* @jsx React.DOM ###

modulejs.define 'r.v.games.Game', ['vr.classes'], ( classes )->
  React.createClass
    render: ->
      game = @props.game
      className = classes 'game tr', participated: game.participated

      matching = true

      columns = {}
      for name, filter of @props.fields
        method = @['field_'+name]
        value = if method != undefined then method(game) else game[name]
        columns[name] = `<span className={classes('td',name)}>{value}</span>`

        if matching && filter && !filter.test value
          matching = false

      className.add not_matching: !matching

      `<a className={className} href={game.url}>
        {columns}
      </a>`
