###* @jsx React.DOM ###

modulejs.define 'vr.input.Select', 
  ['vr.input.getOptions', 'vr.classes']
  ( getOptions, classes )->

    React.createClass
      render: ->
        options = getOptions @props.collection, ( value, label )->
          `<option key={value} value={value}>{label}</option>`

        options.unshift `<option value=''></option>` if @props.allow_blank != false

        `<select
          id={this.props.id}
          className={classes(this.props.className,'input_select')}
          name={this.props.name}
          value={this.props.value}
          defaultValue={this.props.defaultValue}
          onChange={this.props.onChange}
        >
          {options}
        </select>`


