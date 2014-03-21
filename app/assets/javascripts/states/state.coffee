@klass = {}

class klass.State
  initialized: false
  turned: false
  childs: []

  initials: {}
  resets: {}
  toggls: {}


  add: (childs)->
    for child in childs
      @childs.push child
      child.parent = this

    return this


  turn: (bool)->
    return if @turned == bool
    @turned = bool

    # initialization
    if @initialized == false && bool
      @set_state_variables @initials
      @initialize && @initialize()
      @initialized = true

    # fundamental behaviour
    if bool
      @parent && @parent.turn true
    else
      child.turn false for child in @childs

    # callbacks and toggle

    @parent && @parent.before_child_toggled && @parent.before_child_toggled(this, bool)

    @before_toggle && @before_toggle(bool)

    @set_state_variables(@resets) if bool

    @toggle && @toggle(bool)

    @toggle_toggls(bool)

    @after_toggle && @after_toggle(bool)

    @parent && @parent.after_child_toggled && @parent.after_child_toggled(this, bool)

    return


  @get_thing_value: ( thing )->
    return $( thing ) if typeof thing == 'string'
    return thing() if typeof thing == 'function'
    return thing


  set_state_variables: (variables)->
    for name, val of variables
      @[name] = State.get_thing_value val
    return
 

  toggle_toggls: (bool)->
    for name, toggl of @toggls
      if bool
        @[name] = State.get_thing_value toggl.target
        target = @[name]
      else
        target = @[name]
        @[name] = undefined


      if toggl['class']
        target.toggleClass toggl['class'], bool

      if toggl['attr']
        target.attr toggl['attr'], bool || null

      if toggl['prop']
        target.prop toggl['prop'], bool


      if toggl.bind
        for e in toggl.bind
          l = e.length
          target[ if bool then 'on' else 'off' ](
              e[0],
              if l == 3 then e[1] else null,
              e[l-1]
            )

    return
