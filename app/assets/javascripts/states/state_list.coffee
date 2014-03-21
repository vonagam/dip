#childs will be turned on automatically and by order
class klass.StateList extends klass.State
  looped: false

  constructor: ()->
    super
    @resets.list_index = 0

  list_move: ()->
    return if @childs.length == 0

    if @childs.length == @list_index  
      return @turn false if @looped == false
      @list_index = 0
    
    @childs[@list_index].turn true
    return

  after_child_toggled: (child, bool)->
    if bool == false
      @list_index += 1
      @list_move()
    return

  after_toggle: (bool)->
    if bool == true
      @list_move()
    return


class klass.StateListLooped extends klass.StateList
  looped: true
