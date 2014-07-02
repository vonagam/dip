###* @jsx React.DOM ###

modulejs.define 'vr.input.Textarea', ['vr.classes'], ( classes )->

  React.createClass
    labelClicked: ->
      $( @refs.input.getDOMNode() ).focus()
      return
    render: ->
      `<textarea
        ref='input'
        id={this.props.id}
        className={classes(this.props.className, 'input_textarea')}
        name={this.props.name}
        value={this.props.value}
        defaultValue={this.props.defaultValue}
        placeholder={this.props.placeholder}
        onChange={this.props.onChange}
      />`
