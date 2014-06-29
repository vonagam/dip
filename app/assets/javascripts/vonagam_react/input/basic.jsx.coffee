###* @jsx React.DOM ###

modulejs.define 'vr.input.Basic', ->

  React.createClass
    labelClicked: ->
      $( @refs.input.getDOMNode() ).focus()
      return
    render: ->
      `<input
        ref='input'
        id={this.props.id}
        className={this.props.className}
        name={this.props.name}
        type={this.props.sub_type}
        value={this.props.value}
        defaultValue={this.props.defaultValue}
        placeholder={this.props.placeholder}
      />`
