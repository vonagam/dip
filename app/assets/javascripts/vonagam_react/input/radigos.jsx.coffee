###* @jsx React.DOM ###

modulejs.define 'vr.input.Radigos', 
  ['vr.input.getOptions', 'vr.classes'] 
  ( getOptions, classes )->

    React.createClass
      getInitialState: ->
        value = 
        if @props.value != undefined
          @props.value
        else if @props.defaultValue != undefined
          @props.defaultValue
        
        value: value
      optionClicked: (e)->
        return if @props.value
        value = e.target.getAttribute 'data-value'
        if @state.value == value
          return if @props.allow_blank == false
          value = null 
        @setState value: value
        return
      render: ->
        optionClicked = @optionClicked
        input_value = @state.value

        options = getOptions @props.collection, ( value, label )->

          className = classes 'radigo', checked: value.toString() == input_value

          `<div
            key={value}
            className={className} 
            data-value={value}
            onMouseDown={optionClicked}
          >
            {label}
          </div>`

        `<div
          className={classes(this.props.className,'input_radigos')}
        >
          <input
            ref='input'
            type='hidden'
            id={this.props.id}
            name={this.props.name}
            value={this.state.value}
            onChange={this.props.onChange}
          />
          {options}
        </div>`


