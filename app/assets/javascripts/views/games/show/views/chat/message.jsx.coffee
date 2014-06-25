###* @jsx React.DOM ###

g.view.Message = React.createClass
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
