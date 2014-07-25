modulejs.define 'vr.input.getOptions', ->
  get_option = ( option )->
    return option() if typeof option == 'function'
    return [option,option] if typeof option != 'object'
    return [option[0],option[1]] if $.isArray option

  ( options, fun )->
    result = []

    if $.isArray options
      for option in options
        result.push fun.apply null, get_option option
    else
      for value, label of options
        result.push fun value, label

    result
