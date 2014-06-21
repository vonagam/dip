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
    options = {}
    @props.collection.forEach ( option )->
      options['key-'+option] = `<option value={option}>{option}</option>`

    `<select
      id={input_id(this.props)} 
      className={objects_classes(this.props)}
      name={input_name(this.props)}
      value={input_value(this.props)}
      required={this.props.required}
    >
      {options}
    </select>`



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

###
<div class="field select optional message_to"><select class="select optional input" id="message_to" name="message[to]"><option value=""></option>
<option value="Russia">Russia</option>
<option value="Turkey">Turkey</option>
<option value="Austria">Austria</option>
<option value="Italy">Italy</option>
<option value="France">France</option>
<option value="England">England</option>
<option value="Germany">Germany</option></select></div>
<div class="field text required message_text"></div>
<button class="button yellow" name="button" type="submit">Отправить</button></form>
###
