###* @jsx React.DOM ###

g.view.Menu = React.createClass
  render: ->
    Rollback = g.view.Rollback
    Delete = g.view.Delete
    Start = g.view.Start
    History = g.view.History
    Timer = g.view.Timer
    Manual = g.view.Manual
    SendOrders = g.view.SendOrders
    Player = g.view.Player
    LinkToRoot = g.view.LinkToRoot

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
