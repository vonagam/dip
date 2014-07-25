modulejs.define 'v.g.s.map.order.isSelectable', ->

  each = ( object, fun )->
    if $.isArray object
      for element in object
        return if false == fun element
    else
      fun object
    return

  ( name, control )->
    result = 
      'data-selected': null
      'data-selectable': null
      'onMouseDown': null

    if control.selecting
      for type, data of control.select
        if data.selectable.indexOf( name ) != -1
          result['data-selectable'] = [control.step, type].join ' ' 
          result['onMouseDown'] = data.callback.bind this, name

      for type, data of control.selected
        each data, ( unit )->
          if unit.area.name == name
            result['data-selected'] = type
            return false
          return

    result
