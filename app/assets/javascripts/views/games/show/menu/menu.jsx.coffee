###* @jsx React.DOM ###

modulejs.define 'v.g.s.Menu',
  [
    'v.g.s.menu.Switch'
    'v.g.s.menu.Rollback'
    'v.g.s.menu.Delete'
    'v.g.s.menu.Start'
    'v.g.s.menu.Participation'
    'v.g.s.menu.History'
    'v.g.s.menu.Timer'
    'v.g.s.menu.Manual'
    'v.g.s.menu.SendOrders'
    'v.g.s.menu.Player'
    'v.g.s.menu.LinkToRoot'
  ]
  ( 
    Switch
    Rollback
    Delete
    Start
    Participation
    History
    Timer
    Manual
    SendOrders
    Player
    LinkToRoot
  )->

    React.createClass
      render: ->
        game = @props.game
        page = @props.page
        user = @props.user

        left_part =
          if game.map_or_info == 'map'
            `<div className='left'>
              <Switch page={page} />
              <Rollback game={game} page={page} />
              <Start game={game} />
              <Participation game={game} />
              <History game={game} page={page} />
              <Timer game={game} />
              <Manual game={game} />
              <SendOrders game={game} page={page} />
            </div>`
          else
            `<div className='left'>
              <Switch page={page} />
              <Delete game={game} />
              <Start game={game} />
              <Participation game={game} />
              <Timer game={game} />
            </div>`

        `<div className='menu container row'>
          {left_part}
          <div className='right'>
            <Player game={game} user={user} />
            <LinkToRoot />
          </div>
        </div>`
