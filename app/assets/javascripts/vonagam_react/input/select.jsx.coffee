###* @jsx React.DOM ###

modulejs.define 'vr.input.Select', ->

  React.createClass
    labelClicked: false
    render: ->
      options = {}
      @props.collection.forEach ( option )->
        if typeof option == 'object'
          value = option.value
          label = option.label
        else
          value = label = option

        options['key-'+option] = `<option value={value}>{label}</option>`

      `<select
        id={this.props.id}
        className={this.props.className}
        name={this.props.name}
        defaultValue={this.props.defaultValue}
      >
        {options}
      </select>`


