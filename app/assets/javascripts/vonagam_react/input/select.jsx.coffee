###* @jsx React.DOM ###

modulejs.define 'vr.input.Select', ['vr.input.getOption'], ( getOption )->

  React.createClass
    labelClicked: false
    render: ->
      options = {}
      @props.collection.forEach ( option_data )->
        option = getOption option_data

        options['key-'+option.value] = 
          `<option value={option.value}>{option.label}</option>`

      `<select
        id={this.props.id}
        className={this.props.className}
        name={this.props.name}
        defaultValue={this.props.defaultValue}
      >
        {options}
      </select>`


