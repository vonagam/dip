###* @jsx React.DOM ###

modulejs.define 'g.v.Menu',
  [
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

        `<div className='menu container row'>
          <div className='left'>
            <Rollback game={game} page={page} />
            <Delete game={game} />
            <Start game={game} />
            <History game={game} page={page} />
            <Timer game={game} />
            <Manual game={game} />
            <SendOrders game={game} page={page} />
          </div>
          <div className='right'>
            <Player game={game} />
            <LinkToRoot />
          </div>
        </div>`
