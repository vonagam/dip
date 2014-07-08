###* @jsx React.DOM ###

modulejs.define 'r.v.games.Game', ['vr.classes'], ( classes )->

  chat_modes = {
    'only_public': 'fa-comment-o',
    'only_private': 'fa-comment',
    'rotation': 'fa-refresh',
    'both': 'fa-comments-o'
  }

  React.createClass
    render: ->
      game = @props.game
      className = classes 'game tr'

      for name, filter of @props.fields
        if filter && !filter.test game[name]
          className.add 'not_matching'
          break

      time_mode = 
        if game.time_mode == 'manual'
          `<i className='fa fa-wrench' />`
        else 
          game.time_mode

      chat_mode = `<i className={'fa '+chat_modes[game.chat_mode]} />`

      is_public = `<i className='fa fa-eye-slash' />` if not game.is_public

      is_participated = `<i className='fa fa-check' />` if @props.is_participated

      `<a className={className} href={Routes.game_path(game.slug)}>
        <div className='name'>{game.name}</div>
        <div className={classes( 'status', game.status )}>{game.states}</div>
        <div className='sides'>{game.sides}</div>
        <div className='time_mode'>{time_mode}</div>
        <div className='chat_mode'>{chat_mode}</div>
        <div className='is_public'>{is_public}</div>
        <div className='is_participated'>{is_participated}</div>
        <div className='created_at'>{game.created_at}</div>
      </a>`
