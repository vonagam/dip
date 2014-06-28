###* @jsx React.DOM ###

modulejs.define 'vr.form.input.Select', 
  ['vr.form.helpers', 'vr.form.input.SelectOption']
  ( h, select_option )->
    
    React.createClass
      render: ->
        options = {}
        @props.collection.forEach ( option )->
          options['key-'+option] = `<select_option label={option} />`

        `<select
          id={h.input_id(this.props)} 
          className={h.objects_classes(this.props)}
          name={h.input_name(this.props)}
          defaultValue={h.input_value(this.props)}
          required={this.props.required}
        >
          {options}
        </select>`
