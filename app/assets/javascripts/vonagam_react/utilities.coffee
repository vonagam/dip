class vr.Classes
  constructor: ->
    @classes = []
    @add_array arguments

  add: ->
    for arg in arguments
      switch typeof arg
        when 'string'
          @classes.push arg if arg
        when 'object'
          for name, value of arg
            @classes.push name if value
    @

  add_array: ( array )->
    @add.apply this, array

  valueOf: ->
    @classes.join ' '

  toString: ->
    @valueOf()


vr.classes = ->
  (new vr.Classes).add_array arguments


vr.stop_event = ( e )->
  e.stopPropagation()
  e.preventDefault()
  return
