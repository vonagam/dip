###* @jsx React.DOM ###

vr.Component = React.createClass
  render: ->
    className = vr.classes 'component', active: @props.active
    inside = if @props.active then @props.children else null
    
    @transferPropsTo(
      `<div className={className}>
        {inside}
      </div>`
    )
