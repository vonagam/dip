class klass.StateUnited extends klass.State
  after_toggle: (bool)->
    if bool == true
      child.turn bool for child in @childs
    return

  after_child_toggled: (turned_child, bool)->
    if bool == false
      @turn bool
    return
