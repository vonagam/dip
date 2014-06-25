###* @jsx React.DOM ###

g.view.Chat = React.createClass
  render: ->
    Window = g.view.Window
    MessageForm = g.view.MessageForm

    `<div className='chat container'>
      <Window 
        game={this.props.game}
        initialMessages={this.props.initialMessages}
        side_channel={this.props.side_channel}
        game_channel={this.props.game_channel}
      />
      <MessageForm
        game={this.props.game}
      />
    </div>`
