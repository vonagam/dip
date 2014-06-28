###* @jsx React.DOM ###

modulejs.define 'vr.form.input.SelectOption', ->

  React.createClass
    render: ->
      value = @props.value ? @props.label
      `<option value={ value }>{this.props.label}</option>`
