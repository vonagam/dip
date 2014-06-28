###* @jsx React.DOM ###

modulejs.define 'vr.form.Fields', 
  [
    'vr.form.Field'
  ]
  ( Field )->

    React.createClass
      render: ->
        fields = {}
        for attr, options of @props.fields
          fields[attr] = $.extend {}, options, @props

        `<div className='fields'>
          {fields}
        </div>`
