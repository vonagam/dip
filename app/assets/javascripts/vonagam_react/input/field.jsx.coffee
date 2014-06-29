###* @jsx React.DOM ###

modulejs.define 'vr.input.Field', ['vr.input.typeByProps','vr.classes'], ( typeByProps, classes )->

  capitaliseFirstLetter = ( string )->
    string.charAt(0).toUpperCase() + string.slice 1

  React.createClass
    labelClicked: ->
      @refs.input.labelClicked()
      return
    render: ->
      type = typeByProps @props
      Input = modulejs.required 'vr.input.' + capitaliseFirstLetter type.type
      container_class = classes 'field', type.type, type.sub_type

      if @props.name

        name = @props.name
        
        id = name.replace /(?:\[|\])/g, (x)-> 
          if x == '[' then '_' else ''

        container_class.add id
    
      if @props.label
        label_class = classes 'label', clickable: Input.labelClicked != false
        label = `<div 
            ref='label' 
            className={label_class}
            onMouseDown={Input.labelClicked != false ? this.labelClicked : null} 
          >
            {this.props.label}
          </div>`

      if @props.hint
        hint = `<div ref='hint' className='hint'>{this.props.hint}</div>`

      if @props.errors
        error = `<div ref='error' className='error'>{this.props.errors[0]}</div>`

      @transferPropsTo(
        `<div className={container_class}>
          {label}
          <Input
            ref='input'
            id={id}
            name={name}
            className='input'
            sub_type={type.sub_type}
            placeholder={this.props.placeholder}
            collection={this.props.collection}
            defaultValue={this.props.defaultValue}
            errors={this.props.errors}
          /> 
          {hint}
          {error}
        </div>`
      )


