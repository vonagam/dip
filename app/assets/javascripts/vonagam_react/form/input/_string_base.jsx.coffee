###* @jsx React.DOM ###

modulejs.define 'vr.form.input.StringBase', ['vr.form.helpers'], ( h )->

  React.createClass
    render: ->
      `<input 
        id={h.input_id(this.props)} 
        className={h.objects_classes(this.props)} 
        type={this.props.type.downcase()}
        name={h.input_name(this.props)}
        defaultValue={h.input_value(this.props)}
        required={this.props.required}
        placeholder={this.props.placeholder}
      />`
