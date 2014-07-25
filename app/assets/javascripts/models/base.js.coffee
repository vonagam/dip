modulejs.define 'm.Base', ->
  class
    constructor: ->
      @set.apply this, arguments
    
    set: ->
      for attrs in arguments
        for key, value of attrs
          if @['set_'+key]
            @['set_'+key] value, attrs
          else
            if @attrs.indexOf(key) > -1
              @[key] = value
      @
