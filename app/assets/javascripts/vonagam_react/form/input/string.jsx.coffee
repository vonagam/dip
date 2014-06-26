###* @jsx React.DOM ###

modulejs.define 'vr.form.input.String', ['vr.form.helpers'], ( h )->

  React.createClass
    render: ->
      `<input 
        id={h.input_id(this.props)} 
        className={h.objects_classes(this.props)} 
        type='text'
        name={h.input_name(this.props)}
        value={h.input_value(this.props)}
        required={this.props.required}
        placeholder={this.props.placeholder}
      />`