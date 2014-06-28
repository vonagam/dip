###* @jsx React.DOM ###

modulejs.define 'vr.input.Field', ['vr.classes'], ( classes )->

  capitaliseFirstLetter = ( string )->
    string.charAt(0).toUpperCase() + string.slice 1

  React.createClass
    labelClicked: ->
      @refs.input.labelClicked()
      return
    render: ->
      container_class = classes.add 'field', @props.type, @props.sub_type

      if @props.name

        name = @props.name
        
        id = name.replace /(?:\[|\])/g, (x)-> 
          if x == '[' then '_' else ''

        container_class.add id
    
      if @props.label
        label = `<div ref='label' className='label' onMouseDown={this.labelClicked}>{this.props.label}</div>`

      if @props.hint
        hint = `<div ref='hint' className='hint'>{this.props.hint}</div>`

      if @props.errors
        error = `<div ref='error' className='error'>{this.props.errors[0]}</div>`

      Input = modulejs.required 'vr.input.' + capitaliseFirstLetter @props.type

      @transferPropsTo(
        `<div className={container_class}>
          {label}
          <Input
            ref='input'
            id={id}
            name={name}
            className='input'
            sub_type={this.props.sub_type}
            placeholder={this.props.placeholder}
            collection={this.props.collection}
            defaultValue={this.props.defaultValue}
            errors={this.props.errors}
          /> 
          {hint}
          {error}
        </div>`
      )


