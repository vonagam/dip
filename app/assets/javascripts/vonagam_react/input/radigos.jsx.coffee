###* @jsx React.DOM ###

modulejs.define 'vr.input.Radigos', 
  ['vr.input.getOption', 'vr.classes'] 
  ( getOption, classes )->

    React.createClass
      getInitialState: ->
        value = 
        if @props.value != undefined
          @props.value
        else if @props.defaultValue != undefined
          @props.defaultValue
        else if !@props.allow_blank && @props.collection?.length > 0
          getOption( @props.collection[0] ).value
        
        value: value
      optionClicked: (e)->
        return if @props.value
        value = e.target.getAttribute 'data-value'
        if @state.value == value
          return unless @props.allow_blank
          value = null 
        @setState value: value
        return
      render: ->
        value = @state.value
        optionClicked = @optionClicked

        options = {}

        for option_data in @props.collection
          option = getOption option_data

          className = classes 'radigo', checked: option.value.toString()==value

          options['key-'+option.value] = 
            `<div 
              className={className} 
              data-value={option.value}
              onMouseDown={optionClicked}
            >
              {option.label}
            </div>`

        `<div
          className={this.props.className}
        >
          <input
            ref='input'
            type='hidden'
            id={this.props.id}
            name={this.props.name}
            value={value}
          />
          {options}
        </div>`


