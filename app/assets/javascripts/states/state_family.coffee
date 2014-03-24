#parent turn off when last child turned off
class klass.StateFamily extends klass.State
  after_child_toggled: (child, bool)->
    return true if super
    return if @turned == false

    if bool == false

      for child in @childs
        return if child.turned == true

      @turn false

    return
