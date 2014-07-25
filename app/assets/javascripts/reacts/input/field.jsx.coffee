###* @jsx React.DOM ###

modulejs.define 'vr.input.Field', ['vr.input.typeByProps','vr.classes'], ( typeByProps, classes )->

  capitaliseFirstLetter = ( string )->
    string.charAt(0).toUpperCase() + string.slice 1

  React.createClass
    labelClicked: ->
      @refs.input.labelClicked?()
      return
    render: ->
      type = typeByProps @props
      Input = modulejs.require 'vr.input.' + capitaliseFirstLetter type.type
      container_class = classes 'field', "field_#{type.type}", type.sub_type, @props.className

      if @props.name
        id = @props.name.replace /[\[\]]/g, (x)-> if x == '[' then '_' else ''
        container_class.add id
    
      if @props.label
        label = `<div ref='label' className='label' onMouseDown={this.labelClicked}>{this.props.label}</div>`

      if @props.hint
        hint = `<div ref='hint' className='hint'>{this.props.hint}</div>`

      if @props.errors
        error = `<div ref='error' className='error'>{this.props.errors[0]}</div>`

      `<div id={this.props.id} className={container_class}>
        <Input
          ref='input'
          id={id}
          name={this.props.name}
          className='input'
          sub_type={type.sub_type}
          placeholder={this.props.placeholder}
          collection={this.props.collection}
          allow_blank={this.props.allow_blank}
          defaultValue={this.props.defaultValue}
          errors={this.props.errors}
          onChange={this.props.onChange}
        />
        {label}
        {hint}
        {error}
      </div>`


