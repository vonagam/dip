###* @jsx React.DOM ###

modulejs.define 'r.v.RootComponent', 
  [ 'vr.classes', 'vr.Button' ]
  ( classes, Button )->
    React.createClass
      render: ->
        className = classes 'component', @props.name, enabled: @props.enabled

        if @props.enabled
          is_opened = @props.page.state.opened_component == @props.name

          button_options = @props.button

          toggle = @props.page.setOpenedComponent.bind null, 
            if is_opened then null else @props.name

          if is_opened
            closer = `<div className='closer' onMouseDown={toggle} />`
            inside = @props.children
            className.add 'opened'
          else
            if @props.children
              button_options.onMouseDown = toggle

          button_options.className = classes button_options.className, 'sezam'
          button_options.text = I18n.t "application.root.#{@props.name}.button"

          button = Button button_options

        @transferPropsTo(
          `<div className={className}>
            {button}
            {closer}
            {inside}
          </div>`
        )
