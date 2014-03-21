#only one child can be turned on in the same time
class klass.StateRadio extends klass.State
  before_child_toggled: (turned_child, bool)->
    if bool == true
      for child in @childs
        if child != turned_child 
          child.turn false
    return
