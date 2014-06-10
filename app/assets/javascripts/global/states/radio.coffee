#only one child can be turned on in the same time
class state.Radio extends state.Base
  before_child_toggled: (turned_child, bool)->
    return true if super

    if bool == true
      for child in @childs
        if child != turned_child 
          child.turn false

    return
