###* @jsx React.DOM ###

modulejs.define 'vr.input.Text', ->

  React.createClass
    labelClicked: ->
      $( @refs.input.getDOMNode() ).focus()
      return
    render: ->
      `<textarea
        ref='input'
        id={this.props.id}
        className={this.props.className}
        name={this.props.name}
        value={this.props.value}
        defaultValue={this.props.defaultValue}
        placeholder={this.props.placeholder}
      />`
