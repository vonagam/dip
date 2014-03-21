#parent turn off when last child turned off
class klass.StateFamily extends klass.State
  after_child_toggled: (child, bool)->
    return if bool == true

    return if child.turned == true for child in @childs

    @turn false

    return
