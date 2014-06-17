###
new Toggl
  Button:
    target: '.button'
    addClass: 'active'
  OptionalInputs:
    condition: -> if this.has_optionals?
    Container:
      target: '.optional_container'
      addClass: 'visible'
    Inputs:
      target: '.input.optional'
      on:
        mousedown: ->
          this.change_state()
          return

  _fun
  _view

  +
  condition
  target

  +
  prop
  class
  attr
  data
  css

  +
  on - off
  show - hide

  +
  append/prepend - detach
  
  +
  trigger

  +
  fun

### 


class Toggl
  constructor: ( @toggls = {}, fun = this, view = doc )->
    @fun_context = @toggls._fun || fun
    @view_context = @toggls._view || view
    @toggled = false
    @cache = {}


  toggle: ( bool )->
    bool = Boolean bool
    return if bool && @toggls.condition?.apply( @fun_context ) == false
    @toggle_toggls bool
    @toggled = bool
    return


  get_value: ( thing, args = [], selector = false )->
    return @apply_context thing, args if typeof thing == 'function'
    return @view_context.find thing if selector && typeof thing == 'string'
    return thing


  simple_manipulation: ( target, field, key, direction )->
    target[field] key, direction || null
    return


  medium_manipulation: ( target, field, hash, direction, false_value )->
    for key, value of hash
      if direction
        target.each (i, element)=>
          q = $ element
          q[field] key, @get_value( value, [q, i] )
          return
      else
        target[field] key, false_value
    return


  apply_context: ( fun, args )->
    fun.apply @fun_context, args


  wrap_context: ( fun )->
    => fun.apply @fun_context, arguments


  on_off: ( bool )->
    if bool then 'on' else 'off'


  toggle_toggls: ( bool )->
    if @toggls.target
      if bool
        target = @get_value @toggls.target, [], true
        @cache.target = target
      else
        target = @cache
        delete @cache.target

    for name, toggl of @toggls

      if /^[A-Z]/.test name
        unless toggl instanceof Toggl
          toggl = new Toggl toggl, @fun_context, @view_context
          @toggls[name] = toggl

        toggl.toggle bool
        continue

      continue if @toggled == bool || !target || /^_/.test( name ) || 
        name == 'target' || name == 'condition'

      if match = name.match /^(add|remove)(\w+)$/
        direction = ( if match[1] == 'add' then true else false ) == bool
        type = match[2]

        if typeof toggl == 'string'
          field = if type == 'Class' then 'toggleClass' else type.toLowerCase()
          @simple_manipulation target, field, toggl, direction

        if typeof toggl == 'object'
          field = if type == 'Class' then 'toggleClass' else type.toLowerCase()
          false_value = if type == 'Css' then '' else null
          @medium_manipulation target, field, toggl, direction, false_value

        continue

      if name == 'trigger'
        if typeof toggl == 'string'
          target.trigger "#{thing}:#{@on_off(bool)}"
        else
          for e in toggl
            target.trigger "#{e}:#{@on_off(bool)}"
        continue

      if name == 'on' || name == 'off'
        direction = ( if name == 'on' then true else false ) == bool
        on_off = @on_off direction

        for key, value of toggl

          if typeof value == 'function'
            target[ on_off ]( key, @wrap_context(value) )

          else
            for filter, fun of value
              target[ on_off ]( key, filter, @wrap_context(fun) )
        continue

      if name == 'show' || name == 'hide'
        direction = ( if name == 'show' then true else false ) == bool
        target.toggle direction
        continue

      if name == 'fun'
        @apply_context toggl, [target, bool]
        continue

      if match = name.match /^(ap|pre)(pend|detach)$/
        direction = ( if match[2] == 'pend' then true else false ) == bool
        place = match[1]

        if direction
          sub_target = @get_value toggl, [], true
          @cache[name] = sub_target
        else
          sub_target = @cache[name]
          delete @cache[name]

        if direction
          target[match[1]+'pend'] sub_target
        else
          sub_target.detach() #hmm...

        continue

      if match = name.match /^(ap|pre)(pendTo|detachFrom)$/
        direction = ( if match[2] == 'pendTo' then true else false ) == bool
        place = match[1]

        if direction
          target[match[1]+'pendTo'] @get_value toggl, [], true
        else
          target.detach() #hmm...

        continue

    return
