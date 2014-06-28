###* @jsx React.DOM ###

modulejs.define 'vr.form.input.Hidden', ['vr.form.helpers'], ( h )->

  React.createClass
    render: ->
      `<input 
        id={h.input_id(this.props)} 
        className={h.objects_classes(this.props)} 
        type='hidden'
        name={h.input_name(this.props)}
        defaultValue={h.input_value(this.props)}
      />`
