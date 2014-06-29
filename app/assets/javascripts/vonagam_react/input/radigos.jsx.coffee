###* @jsx React.DOM ###

modulejs.define 'vr.input.Radigos', 
  ['vr.input.getOption', 'vr.classes'] 
  ( getOption, classes )->

    React.createClass
      getInitialState: ->
        value: @props.value ? @props.defaultValue
      optionClicked: (e)->
        log 123
        return if @props.value
        value = e.target.getAttribute 'data-value'
        value = null if @state.value == value
        @setState value: value
        return
      render: ->
        value = @state.value
        optionClicked = @optionClicked

        options = {}
        @props.collection.forEach ( option_data )->
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


