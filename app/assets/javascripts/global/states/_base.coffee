@state = {}

class state.Base
  constructor: ( hash = {} )->
    @initialized = false
    @turned = false

    @initials = hash.initials || {}
    @resets = hash.resets || {}
    @toggls = hash.toggls || {}

    @childs = []
    
    add hash.childs if hash.childs


  add: (childs)->
    for child in childs
      @childs.push child
      child.parent = this

    return this


  turn: (bool)->
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

    return @toggle_toggls bool
    

  @get_thing_value: ( thing )->
    return $( thing ) if typeof thing == 'string'
    return thing() if typeof thing == 'function'
    return thing


  set_variables: (variables)->
    for name, val of variables
      @[name] = Base.get_thing_value val
    return
 

  toggle_toggls: (bool)->
    for name, toggl of @toggls
      if bool
        target = Base.get_thing_value toggl.target

        return true if target == 42

        @[name] = target
      else
        target = @[name]

        continue if target == undefined

        @[name] = undefined


      if toggl['class']
        target.toggleClass toggl['class'], bool

      if toggl['attr']
        target.attr toggl['attr'], bool || null

      if toggl['prop']
        target.prop toggl['prop'], bool

      if toggl['bind']
        for e, fun of toggl['bind']

          if typeof fun == 'function'
            filter = null
          else
            filter = fun[0]
            fun = fun[1]

          target[ if bool then 'on' else 'off' ]( e, filter, fun )

    return
