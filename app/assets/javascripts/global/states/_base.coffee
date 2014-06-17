@state = {}

class state.Base
  constructor: ( hash = {} )->
    @initialized = false
    @turned = false

    @initials = hash.initials || {}
    @resets = hash.resets || {}

    @toggls = new Toggler hash.toggls, this

    @childs = []
    
    add hash.childs if hash.childs


  add: (childs)->
    for child in childs
      @childs.push child
      child.parent = this

    return this


  turn: (bool)->
    bool = Boolean bool

    return if @turned == bool

    @turned = bool

    return if @parent && @parent.before_child_toggled this, bool

    return if @toggle bool

    return if @parent && @parent.after_child_toggled this, bool

    return


  before_child_toggled: (child, bool)->
    @turn true if bool == true
    return

  after_child_toggled: (child, bool)->
    return

  toggle: (bool)->
    if @initialized == false
      @initialized = true
      @set_variables @initials

    if bool
      @set_variables @resets
    else
      child.turn false for child in @childs

    @toggls.toggle bool

    return true if @toggls.toggled != bool
    
    return
    

  @get_thing_value: ( thing )->
    return $( thing ) if typeof thing == 'string'
    return thing() if typeof thing == 'function'
    return thing


  set_variables: (variables)->
    for name, val of variables
      @[name] = Base.get_thing_value val
    return
