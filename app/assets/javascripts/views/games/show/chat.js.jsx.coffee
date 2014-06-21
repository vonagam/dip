###* @jsx React.DOM ###



Message = React.createClass
  name_span: ( name )->
    `<span className={ vr.classes( name, name == this.props.user_name ) }>
      { name }
    </span>`

  time_format: ( created_at )->
    (new Date(created_at)).toTimeString().replace(/^(\S+)\s+.+$/, "$1")

  render: ->
    message = this.props.message

    `<div className={ vr.classes( 'message', message.public ? 'public' : 'private' ) }>
      <div className='created_at'>{this.time_format(message.created_at)}</div>
      <div className='from'>{this.name_span(message.from)}</div>
      <div className='to'>{this.name_span(message.to)}</div>
      <div className='text'>{message.text}</div>
    </div>`



Window = React.createClass
  render: ->
    messages = {}
    user_name = @props.user_name

    @props.messages.forEach (message)->
      messages[message.id] = `<Message message={message} user_name={user_name}/>`

    `<div className='window'>
      {messages}
    </div>`



MessageForm = React.createClass
  render: ->
    Form = vr.Form
    Field = vr.Field
    Button = vr.SubmitButton

    `<Form 
      id='new_message'
      action='/games/exampl2/messages.json'
      method='post'
      className='new_message'
      no_redirect='true'
      remote='true'
    >
      <Field for='message' attr='to' label='hello' type='select' collection={['','1','2']} />
      <Field for='message' attr='text' type='text' placeholder='message' />
      <Button className='yellow' text='send' />
    </Form>`



vr.Chat = React.createClass
  render: ->
    user_name = @props.user_side?.name
    `<div className='chat container'>
      <Window messages={this.props.messages} user_name={user_name} />
      <MessageForm user_side={this.props.user_side} />
    </div>`


