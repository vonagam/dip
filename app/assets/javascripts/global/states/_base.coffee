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

    if typeof bool != 'boolean'
      log 'state turn: not boolean bool'

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

      if toggl['data']
        for name, thing of toggl['data']
          target.data name, if bool then Base.get_thing_value(toggl.target) else null

      on_off = if bool then 'on' else 'off'
      
      if toggl['bind']
        for e, thing of toggl['bind']

          if typeof thing == 'function'
            target[ on_off ]( e, thing )
          else
            for filter, fun of thing
              target[ on_off ]( e, filter, fun )

      if toggl['trigger']
        thing = toggl['trigger']

        if typeof thing == 'string'
          target.trigger "#{thing}:#{on_off}"
        else
          for e in thing
            target.trigger "#{e}:#{on_off}"

    return
