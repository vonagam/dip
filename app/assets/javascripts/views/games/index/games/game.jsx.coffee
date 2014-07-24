###* @jsx React.DOM ###

modulejs.define 'r.v.games.Game', ['vr.classes', 'icons'], ( classes, icons )->

  React.createClass
    render: ->
      game = @props.game
      className = classes 'game tr'
      game_icons = icons.Game.values

      values = {}
      for field in @props.fields
        if field == 'status'
          values[field] = `<div className={classes( 'status', game.status )}>{game.states_count}</div>`
          continue

        value = game[field]
        icon = game_icons[field] && game_icons[field][value]

        visual = switch icon
          when undefined then value
          when 0 then null
          else icons.get icon

        values[field] = `<div className={field}>{visual}</div>`

      `<a className={className} href={Routes.game_path(game.slug)}>{values}</a>`
