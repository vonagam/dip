###* @jsx React.DOM ###

modulejs.define 'vr.input.Text', ->

  React.createClass
    labelClicked: ->
      @refs.input.focus()
      return
    render: ->
      `<textarea
        ref='input'
        id={this.props.id}
        className={this.props.className}
        name={this.props.name}
        defaultValue={this.props.defaultValue}
        placeholder={this.props.placeholder}
      />`
