###* @jsx React.DOM ###

modulejs.define 'v.g.s.chat.Window', [ 'v.g.s.chat.Message' ], ( Message )->

  React.createClass
    state_from_messages: ( messages, initial = [] )->
      messages.reverse()

      messages: messages.concat initial
      all: messages.length < 10
      offset: if messages.length > 0 then messages[0].created_at else null
    add_new_message: ( message )->
      @setState messages: @state.messages.concat message
      return
    add_old_messages: ( messages )->
      @old_adding = true
      @setState @state_from_messages messages, @state.messages
      return
    bind_channel: ( channel )->
      channel.bind 'message', ( message )=> @add_new_message message
      return
    scroll_to: ( bottom )->
      node = @getDOMNode()
      node.scrollTop = node.scrollHeight - bottom
      return
    fetch: ->
      $(@getDOMNode()).ajax 'get', "/games/#{@props.game.id}/messages.json",
        offset: @state.offset
        ( messages )=>
          @add_old_messages messages
          return
      return
    onScroll: (e)->
      @fetch() if @getDOMNode().scrollTop < 20  
      return
    getInitialState: ->
      @state_from_messages @props.game.messages
    componentWillUpdate: ->
      node = @getDOMNode()
      @distance_from_bottom = node.scrollHeight - node.scrollTop
      @shouldScrollBottom = @distance_from_bottom <= node.offsetHeight
      return
    componentDidUpdate: ->
      if @old_adding
        @scroll_to @distance_from_bottom
        @old_adding = null
      else
        @scroll_to 0 if @shouldScrollBottom
      return
    componentDidMount: ->
      @scroll_to 0
    componentWillMount: ->
      @bind_channel @props.game_channel
      return
    render: ->
      game = @props.game
      messages = {}
      user_name = game.user_side?.name

      if @user_name != user_name && user_name
        @bind_channel @props.side_channel

      @user_name = user_name

      for message in @state.messages
        messages[message._id] = `<Message message={message} user_name={this.user_name} />`

      `<div className='window' onScroll={ this.state.all ? null : this.onScroll }>
        {messages}
      </div>`
