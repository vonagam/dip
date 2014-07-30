###* @jsx React.DOM ###

modulejs.define 'v.g.s.Chat',
  [
    'v.g.s.chat.Window'
    'v.g.s.chat.Form'
  ]
  ( Window, Form )->

    React.createClass
      render: ->
        `<div className='chat container'>
          <Window 
            game={this.props.game}
            side_channel={this.props.side_channel}
            game_channel={this.props.game_channel}
          />
          <Form
            game={this.props.game}
          />
        </div>`
