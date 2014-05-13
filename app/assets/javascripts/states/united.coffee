class state.United extends state.Base
  toggle: (bool)->
    return true if super

    if bool == true
      child.turn true for child in @childs

    return

  after_child_toggled: (turned_child, bool)->
    return true if super

    if bool == false
      @turn bool

    return
