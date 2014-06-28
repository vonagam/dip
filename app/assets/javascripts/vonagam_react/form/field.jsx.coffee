###* @jsx React.DOM ###

modulejs.define 'vr.form.Field', 
  [
    'vr.form.helpers'
    'vr.form.Label'
  ]
  ( h, Label )->

    React.createClass
      render: ->
        @props.type ||= 'String'

        label = Label @props if @props.label
        input = modulejs.require('vr.form.input.'+@props.type) @props

        `<div className={h.objects_classes(this.props, 'field')}>
          {label}
          {input}
        </div>`
