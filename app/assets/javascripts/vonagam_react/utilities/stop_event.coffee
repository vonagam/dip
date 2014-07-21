modulejs.define 'vr.stopEvent', ->
  ( e )->
    e.stopPropagation()
    e.preventDefault()
    return
