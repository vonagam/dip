###* @jsx React.DOM ###

modulejs.define 'vr.Component', 
  [ 'vr.classes' ]
  ( classes )->

    React.createClass
      render: ->
        className = classes 'component', disabled: !@props.active
        inside = if @props.active then @props.children else null
        
        @transferPropsTo(
          `<div className={className}>
            {inside}
          </div>`
        )
