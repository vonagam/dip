###* @jsx React.DOM ###

modulejs.define 'r.v.RootComponent', 
  [ 'vr.classes', 'vr.Button' ]
  ( classes, Button )->
    React.createClass
      render: ->
        className = classes 'component', @props.name, disabled: !@props.enabled

        if @props.enabled
          is_opened = @props.page.state.active_component == @props.name

          button_options = @props.button

          toggle = @props.page.setActiveComponent.bind null, 
            if is_opened then null else @props.name

          if is_opened
            closer = `<div className='closer' onMouseDown={toggle} />`
            inside = @props.children
          else
            className.add 'closed'
            button_options.onMouseDown = toggle

          button = Button button_options

        @transferPropsTo(
          `<div className={className}>
            {button}
            {closer}
            {inside}
          </div>`
        )
