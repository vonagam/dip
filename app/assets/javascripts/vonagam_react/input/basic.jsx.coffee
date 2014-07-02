###* @jsx React.DOM ###

modulejs.define 'vr.input.Basic', ['vr.classes'], ( classes )->

  React.createClass
    labelClicked: ->
      $( @refs.input.getDOMNode() ).focus()
      return
    render: ->
      `<input
        ref='input'
        id={this.props.id}
        className={classes(this.props.className,'input_basic')}
        name={this.props.name}
        type={this.props.sub_type}
        value={this.props.value}
        defaultValue={this.props.defaultValue}
        placeholder={this.props.placeholder}
        onChange={this.props.onChange}
      />`
