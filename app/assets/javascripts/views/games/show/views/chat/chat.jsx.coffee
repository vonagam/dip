###* @jsx React.DOM ###

modulejs.define 'g.v.Chat',
  [
    'g.v.chat.Window'
    'g.v.chat.Form'
  ]
  ( Window, Form )->

    React.createClass
      render: ->
        `<div className='chat container'>
          <Window 
            game={this.props.game}
            initialMessages={this.props.initialMessages}
            side_channel={this.props.side_channel}
            game_channel={this.props.game_channel}
          />
          <Form
            game={this.props.game}
          />
        </div>`
