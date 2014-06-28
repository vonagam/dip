###* @jsx React.DOM ###

modulejs.define 'vr.form.input.Text', ['vr.form.helpers'], ( h )->
  
  React.createClass
    render: ->
      `<textarea 
        id={h.input_id(this.props)} 
        className={h.objects_classes(this.props)}
        name={h.input_name(this.props)}
        defaultValue={h.input_value(this.props)}
        required={this.props.required}
        placeholder={this.props.placeholder}
      />`
