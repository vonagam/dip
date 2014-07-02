###* @jsx React.DOM ###

modulejs.define 'vr.input.Checkboxer', ['vr.classes'], ( classes )->

  React.createClass
    getInitialState: ->
      value: +Boolean @props.value ? @props.defaultValue
    onMouseDown: (e)->
      @setState value: 1-@state.value
      return
    labelClicked: ->
      @onMouseDown()
      return
    render: ->
      value = @state.value
      className = classes this.props.className, 'input_checkboxer', checked: value

      `<div className={className} onMouseDown={this.onMouseDown}>
        <input
          ref='input'
          type='hidden'
          id={this.props.id}
          name={this.props.name}
          value={value}
          onChange={this.props.onChange}
        />
      </div>`


