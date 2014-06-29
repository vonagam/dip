modulejs.define 'vr.input.typeByProps', ->
  ( props )->
    if props.type
      return type: props.type, sub_type: props.sub_type

    if props.sub_type
      return type: 'basic', sub_type: props.sub_type

    name = props.name

    if /(?:[\[_]|^)is(?:[\]_]|$)/.test name
      return type: 'checkbox'

    if /email/.test name
      return type: 'basic', sub_type: 'email'

    if /password/.test name
      return type: 'basic', sub_type: 'password'

    if /(?:description|text)/
      return type: 'text'

    if props.collection
      return type: 'select'

    type: 'basic', sub_type: 'text'
