###* @jsx React.DOM ###

modulejs.define 'vr.form.Label', ['vr.form.helpers'], ( h )->

  React.createClass
    render: ->
      `<label 
        htmlFor={h.input_id(this.props)} 
        className={h.objects_classes(this.props, 'label')}
      >
        {this.props.label}
      </label>`
