###* @jsx React.DOM ###

Component = vr.Component



vr.Chat = React.createClass
  render: ->
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



Window = React.createClass
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
    $(@getDOMNode()).ajax 'get', "/games/#{@props.game.data.id}/messages.json",
      offset: @state.offset
      ( messages )=>
        @add_old_messages messages
        return
    return
  onScroll: (e)->
    @fetch() if @getDOMNode().scrollTop < 20  
    return
  getInitialState: ->
    @state_from_messages @props.initialMessages
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
    messages = {}
    user_name = @props.game.user_side?.name

    if @user_name != user_name && user_name
      @bind_channel @props.side_channel

    @user_name = user_name

    for message in @state.messages
      messages[message._id] = `<Message message={message} user_name={this.user_name} />`

    `<div className='window' onScroll={ this.state.all ? null : this.onScroll }>
      {messages}
    </div>`



Message = React.createClass
  name_span: ( name )->
    `<span 
      className={vr.classes( name, { 'self': name == this.props.user_name } )}
    >
      { name }
    </span>`

  time_format: ( created_at )->
    (new Date(created_at)).toTimeString().replace(/^(\S+)\s+.+$/, "$1")

  render: ->
    message = this.props.message

    `<div className={ vr.classes( 'message', message.is_public ? 'public' : 'private' ) }>
      <div className='created_at'>{this.time_format(message.created_at)}</div>
      <div className='from'>{this.name_span(message.from)}</div>
      <div className='to'>{this.name_span(message.to)}</div>
      <div className='text'>{message.text}</div>
    </div>`



MessageForm = React.createClass
  componentDidMount: ()->
    node = $ @getDOMNode()
    node.on 'ajax:success', ->
      node.find('textarea').val ''
      return
    return
  private_is_available: ( game )->
    game.data.status == 'going' && !game.data.chat_is_public
  form_is_available: ( game )->
    switch game.data.status
      when 'waiting' then true
      when 'going' then game.user_side && game.user_side.status != 'lost'
      when 'ended' then game.user_side
  onKeyDown: (e)->
    if e.shiftKey
      switch e.which
        when 13 then $(@refs.form.getDOMNode()).submit()
    return
  render: ->
    Form = vr.Form
    Field = vr.Field
    Button = vr.SubmitButton

    game = this.props.game

    active = @form_is_available game

    if active && @private_is_available game
      options = []
      options.push if game.data.chat_mode == 'both' then 'Public' else ''
      
      for side in game.data.sides
        if ( side.status == 'fighting' || side.status == 'draw' ) && side != game.user_side
          options.push side.name


      to_select = `<Field 
        for='message' attr='to'
        type='select' label='hello'
        collection={options} 
      />`

    `<Component active={active}>
      <Form
        ref='form'
        id='new_message'
        action={Routes.game_messages_path( game.data.id, { format: 'json' } )}
        method='post'
        className='new_message'
        no_redirect='true'
        remote='true'
        onKeyDown={this.onKeyDown}
      >
        {to_select}
        <Field for='message' attr='text' type='text' placeholder='message' />
        <Button className='yellow' text='send' />
      </Form>
    </Component>`
