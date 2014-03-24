#childs will be turned on automatically and by order
class klass.StateList extends klass.State
  constructor: ->
    super
    @resets.list_index = 0

  list_move: ->
    return if @childs.length == 0

    if @childs.length == @list_index && @after_list_end() == true
      @turn false
      return
    
    @childs[@list_index].turn true
    return

  after_list_end: ->
    return true

  after_child_toggled: (child, bool)->
    return true if super
    return if @turned == false

    if bool == false
      @list_index += 1
      @list_move()
    return

  toggle: (bool)->
    return true if super

    @list_move() if bool == true
    
    return


class klass.StateListLooped extends klass.StateList
  after_list_end: ->
    @list_index = 0
    return
