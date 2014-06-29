###* @jsx React.DOM ###

modulejs.define 'vr.form.Field', ['vr.input.Field'], ( Field )->
  React.createClass
    render: ->
      if @props.for
        name = "#{@props.for}[#{@props.attr}]"
      else
        name = @props.attr || @props.name

      if @props.object
        value = @props.object[@props.attr]
      else
        value = @props.value

      @transferPropsTo(
        `<Field name={name} defaultValue={value} />`
      )
