###* @jsx React.DOM ###



objects_classes = ( props, additional = 'input' )->
  vr.classes(
    input_id props
    props.type || 'string'
    required: props.required
    optional: !props.required
  ).add additional

input_id = ( props )->
  "#{props.for}_#{props.attr}"
input_name = ( props )->
  "#{props.for}[#{props.attr}]"
input_value = ( props )->
  props.for?[props.attr]



vr.Input = {}



vr.Input.string = React.createClass
  render: ->
    `<input 
      id={input_id(this.props)} 
      className={objects_classes(this.props)} 
      type='text'
      name={input_name(this.props)}
      value={input_value(this.props)}
      required={this.props.required}
      placeholder={this.props.placeholder}
    />`



vr.Input.select = React.createClass
  render: ->
    select_option = vr.Input.select_option

    options = {}
    @props.collection.forEach ( option )->
      options['key-'+option] = `<select_option label={option} />`

    `<select
      id={input_id(this.props)} 
      className={objects_classes(this.props)}
      name={input_name(this.props)}
      value={input_value(this.props)}
      required={this.props.required}
    >
      {options}
    </select>`



vr.Input.select_option = React.createClass
  render: ->
    value = @props.value ? @props.label
    `<option value={ value }>{this.props.label}</option>`



vr.Input.text = React.createClass
  render: ->
    `<textarea 
      id={input_id(this.props)} 
      className={objects_classes(this.props)}
      name={input_name(this.props)}
      value={input_value(this.props)}
      required={this.props.required}
      placeholder={this.props.placeholder}
    />`



vr.Label = React.createClass
  render: ->
    `<label 
      htmlFor={input_id(this.props)} 
      className={objects_classes(this.props, 'label')}
    >
      {this.props.label}
    </label>`



vr.Field = React.createClass
  render: ->
    type = @props.type || 'string'

    label = vr.Label @props if @props.label
    input = vr.Input[type] @props

    `<div className={objects_classes(this.props, 'field')}>
      {label}
      {input}
    </div>`



vr.Button = React.createClass
  render: ->
    @transferPropsTo(
      `<a
        className='button'
        data-remote={this.props.remote} remote={null}
        data-method={this.props.method} method={null}
        data-confirm={this.props.confirm} confirm={null}
      >
        {this.props.text}
        {this.props.children}
      </a>`
    )



vr.SubmitButton = React.createClass
  render: ->
    @transferPropsTo(
      `<button
        type='submit'
        className='button'
      >
        {this.props.text}
        {this.props.children}
      </button>`
    )



vr.Form = React.createClass
  render: ->
    @transferPropsTo(
      `<form 
        accept-charset='UTF-8'
        className='form'
        data-remote={this.props.remote} remote={null}
        data-no-redirect={this.props.no_redirect} no_redirect={null}
      >
        <div style={{display:'inline'}}><input name='utf8' type='hidden' value='✓' /></div>
        {this.props.children}
      </form>`
    )
