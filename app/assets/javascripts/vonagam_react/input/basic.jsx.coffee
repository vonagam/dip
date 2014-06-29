###* @jsx React.DOM ###

modulejs.define 'vr.input.String', ->

  React.createClass
    labelClicked: ->
      @refs.input.focus()
      return
    render: ->
      `<input
        ref='input'
        id={this.props.id}
        className={this.props.className}
        name={this.props.name}
        type={this.props.sub_type}
        defaultValue={this.props.defaultValue}
        placeholder={this.props.placeholder}
      />`
