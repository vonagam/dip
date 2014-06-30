###* @jsx React.DOM ###

modulejs.define 'vr.input.Select', ['vr.input.getOption'], ( getOption )->

  React.createClass
    render: ->
      options = {}

      if @props.allow_blank
        options['key'] = `<option value=''></option>`

      @props.collection.forEach ( option_data )->
        option = getOption option_data

        options['key-'+option.value] = 
          `<option value={option.value}>{option.label}</option>`

      `<select
        id={this.props.id}
        className={this.props.className}
        name={this.props.name}
        value={this.props.value}
        defaultValue={this.props.defaultValue}
      >
        {options}
      </select>`


