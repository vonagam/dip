modulejs.define 'vr.input.getOptions', ->
  ( options, fun )->
    result = []

    if $.isArray options
      if options.length > 0
        if typeof options[0] == 'object'
          [value,label] = if $.isArray options[0] then [0,1] else ['value','label']
          for option in options
            result.push fun option[value], option[label]
        else
          for option in options
            result.push fun option, option
    else
      for value, label of options
        result.push fun value, label

    result
