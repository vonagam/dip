modulejs.define 'vr.form.helpers',
  [ 'vr.classes' ]
  ( classes )->
    objects_classes: ( props, additional = 'input' )->
      classes(
        @input_id props
        props.type || 'string'
        required: props.required
        optional: !props.required
      ).add additional

    input_id: ( props )->
      "#{props.for}_#{props.attr}"
    input_name: ( props )->
      "#{props.for}[#{props.attr}]"
    input_value: ( props )->
      props.for?[props.attr]
