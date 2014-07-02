modulejs.define 'vr.input.typeByProps', ->

  mapping = [
    [ /(?:[\[_]|^)is(?:[\]_]|$)/, type: 'checkboxer' ]
    [ /email/, type: 'basic', sub_type: 'email' ]
    [ /password/, type: 'basic', sub_type: 'password' ]
    [ /(?:description|text)/, type: 'textarea' ]
  ]

  ( props )->
    if props.type
      return type: props.type, sub_type: props.sub_type

    if props.sub_type
      return type: 'basic', sub_type: props.sub_type

    if props.collection
      return type: 'select'

    for check in mapping
      return check[1] if check[0].test props.name

    type: 'basic', sub_type: 'text'
