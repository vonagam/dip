###* @jsx React.DOM ###

modulejs.define 'r.v.games.Game', ['vr.classes'], ( classes )->
  React.createClass
    field_creator: (game)->
      game.creator.login
    render: ->
      game = @props.game

      columns = {}
      for name, filter of @props.fields
        method = @['field_'+name]
        value = if method != undefined then method(game) else game[name]
        columns[name] = `<span className={classes('td',name)}>{value}</span>`

      `<a 
        className={classes( 'game tr', {'participated': this.props.game.participated} )}
        href={ this.props.game.url }
      >
        {columns}
      </a>`
