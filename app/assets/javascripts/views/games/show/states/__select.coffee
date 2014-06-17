class g.SelectingState extends state.Base
  constructor: ( hash )->
    super

    @select_selecting = hash.selecting if hash.selecting
    @select_marking = hash.marking if hash.marking
    @select_container = hash.container if hash.container

    possibles = target: @select_selecting

    if match = @select_marking.match /^\[(.+)\]$/
      possibles.addAttr = match[1]
    else
      possibles.addClass = @select_marking

    litener = {}
    litener[ @select_marking ] = (e)->
      return if e.which && e.which != 1
      @selected = $(e.target).closest @select_marking
      @turn false
      return false

    data = {}
    data[ @select_marking ] = -> @selected

    @toggls.add
      Possibles: possibles
      Container:
        target: @select_container
        on: mousedown: litener
        removeData: data
