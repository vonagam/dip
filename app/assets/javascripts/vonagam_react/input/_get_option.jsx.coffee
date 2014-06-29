modulejs.define 'vr.input.getOption', ->
  ( option_data )->
    r = {}

    if typeof option == 'object'
      if $.isArray option
        r.value = option[0]
        r.label = option[1]
      else
        r.value = option.value
        r.label = option.label
    else
      r.value = r.label = option

    r
