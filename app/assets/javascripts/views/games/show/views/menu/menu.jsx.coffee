###* @jsx React.DOM ###

modulejs.define 'g.v.Menu',
  [
    'g.v.menu.Switch'
    'g.v.menu.Rollback'
    'g.v.menu.Delete'
    'g.v.menu.Start'
    'g.v.menu.History'
    'g.v.menu.Timer'
    'g.v.menu.Manual'
    'g.v.menu.SendOrders'
    'g.v.menu.Player'
    'g.v.menu.LinkToRoot'
  ]
  ( 
    Switch
    Rollback
    Delete
    Start
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

        left_part =
          if game.map_or_info == 'map'
            `<div className='left'>
              <Switch page={page} />
              <Rollback game={game} page={page} />
              <Start game={game} />
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
              <Timer game={game} />
            </div>`

        `<div className='menu container row'>
          {left_part}
          <div className='right'>
            <Player game={game} />
            <LinkToRoot />
          </div>
        </div>`
