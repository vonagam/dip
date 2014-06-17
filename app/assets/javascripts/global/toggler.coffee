class @Toggler
  constructor: ( toggls = {}, fun, view )->
    @fun_context = fun
    @view_context = view
    @parent = null
    @toggled = false
    @manipulations = []
    @sub_togglers = {}

    @add toggls


  get_view_context: ->
    @view_context || ( if @parent then @parent.get_view_context() else doc )
  get_fun_context: ->
    @fun_context || ( if @parent then @parent.get_fun_context() else this )


  toggle: ( bool )->
    bool = Boolean bool
    
    return if bool && @condition && @apply_context( @condition ) == false
    
    sub_toggler.toggle bool for name, sub_toggler of @sub_togglers
    
    return if bool == @toggled

    if @target
      target = @get_target bool
      return if typeof target != 'object'
      manipulation.toggle this, target, bool for manipulation in @manipulations

    @toggled = bool
    return


  get_target: ( bool )->
    if bool
      target = @get_value @target, [], true
      @cache = target
    else
      target = @cache
      delete @cache
    return target


  get_value: ( thing, args, selector = false )->
    return @apply_context thing, args if typeof thing == 'function'
    return @get_view_context().find thing if selector && typeof thing == 'string'
    return thing


  apply_context: ( fun, args = [] )->
    fun.apply @get_fun_context(), args


  wrap_context: ( fun )->
    => fun.apply @get_fun_context(), arguments


  get: ( path )->
    if path
      path = path.split '.'
      @sub_togglers[ path.shift() ].get path.join '.'
    else
      @cache


  add: ( toggls )->
    for name, toggl of toggls

      if /^[A-Z]/.test name
        unless toggl instanceof Toggler
          toggl = new Toggler toggl

        toggl.parent = this

        @sub_togglers[name] = toggl
        continue

      if name == 'target' || name == 'condition'
        @[name] = toggl
        continue

      if /^_/.test( name )
        if match = name.match /^_(\w+)$/
          @[match[1]+'_context'] = toggl
        continue

      m = @new_manipulation name, toggl
      @manipulations.push m if m

    return

  new_manipulation: ( name, toggl )->
    if match = name.match /^(add|remove)(\w+)$/
      direction = match[1] == 'add'
      type = match[2]
      field = if type == 'Class' then 'toggleClass' else type.toLowerCase()
      if typeof toggl == 'string'
        return new manipulation.Simple field, toggl, direction
      if typeof toggl == 'object'
        return new manipulation.Medium field, toggl, direction

    if name == 'trigger'
      return new manipulation.Trigger toggl

    if name == 'on' || name == 'off'
      direction = name == 'on'
      return new manipulation.Bind toggl, direction

    if name == 'show' || name == 'hide'
      direction = name == 'show'
      return new manipulation.Toggle direction

    if name == 'fun'
      return new manipulation.Fun toggl

    if match = name.match /^(ap|pre)(pend|detach)$/
      direction = match[2] == 'pend'
      order = match[1]
      return new manipulation.Pend toggl, order, direction

    if match = name.match /^(ap|pre)(pendTo|detachFrom)$/
      direction = match[2] == 'pendTo'
      order = match[1]
      return new manipulation.PendTo toggl, order, direction

    return null


manipulation = {}

class manipulation.Base
  constructor: ( @direction )->

  toggle: ( toggler, target, bool )->
    @change toggler, target, @direction == bool
    return

  on_off: ( bool )->
    if bool then 'on' else 'off'


class manipulation.Simple extends manipulation.Base
  constructor: ( @field, @key, direction )->
    super direction

  change: ( toggler, target, direction )->
    target[@field] @key, direction || null
    return


class manipulation.Medium extends manipulation.Base
  constructor: ( @field, @hash, direction )->
    super direction

  change: ( toggler, target, direction )->
    false_value = if @field == 'css' then '' else null

    for key, value of @hash
      if direction
        target.each (i, element)=>
          q = $ element
          q[@field] key, toggler.get_value( value, [q, i] )
          return
      else
        target[@field] key, false_value
    return


class manipulation.Toggle extends manipulation.Base
  change: ( toggler, target, direction )->
    target.toggle direction
    return


class manipulation.Trigger extends manipulation.Base
  constructor: ( @events )->

  toggle: ( toggler, target, bool )->
    on_off = @on_off bool

    for e in @events.split(' ')
      target.trigger "#{e}:#{on_off}"
    
    return


class manipulation.Bind extends manipulation.Base
  constructor: ( @hash, direction )->
    super direction
    @cache = {}

  change: ( toggler, target, direction )->
    for key, value of @hash
      if typeof value == 'function'
        @bind toggler, target, direction, key, null, value
      else
        for filter, fun of value
          @bind toggler, target, direction, key, filter, fun
    return

  bind: ( toggler, target, direction, key, filter, fun )->
    cache_key = "#{key}|#{filter}"
    
    if direction
      listener = toggler.wrap_context fun
      @cache[cache_key] = listener
    else
      listener = @cache[cache_key]
      delete @cache[cache_key]

    target[@on_off(direction)] key, filter, listener
    return


class manipulation.Fun extends manipulation.Base
  constructor: ( @fun )->

  toggle: ( toggler, target, bool )->
    toggler.apply_context @fun, [target, bool]
    return


class manipulation.Pend extends manipulation.Base
  constructor: ( @order, @place, direction )->
    super direction

  change: ( toggler, target, direction )->
    if direction
      whom = toggler.get_value @place, [], true
      target[@order+'pend'] whom
      @cache = whom
    else
      @cache.detach()
      delete @cache
    return


class manipulation.PendTo extends manipulation.Base
  constructor: ( @place, @order, direction )->
    super direction

  change: ( toggler, target, direction )->
    if direction
      target[@order+'pendTo'] @get_value @place, [], true
    else
      target.detach()
    return
