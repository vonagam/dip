class r.view.Base extends BP.View
  constructor: ( @root, @container_class, permanent = false )->
    super @root, @container_class, ".#{@container_class}.container"
 
    @toggls.add Status: target: @view, addClass: 'opened'

    @view.find('.form .button, .sezam').clicked =>
      if @enabled && @turned == false
        @turn true
      return

    @view.find('.closer').clicked =>
      if @turned == true
        @turn false
      return

    @enable true if permanent
    @toggle_form false


  update: ->
    @enable @is_enable()
    return


  find: ( selector )->
    @view.find selector


  enable: ( bool )->
    return if @enabled == bool

    @turn false if bool == false && @turned

    @enabled = bool

    @view
    .removeClass 'enabled disabled'
    .addClass if bool then 'enabled' else 'disabled'

    return


  toggle: ( bool )->
    super

    ###
    if bool
      window.location.hash = @container_class
    else
      window.location.hash = ''
    ###

    @toggle_form bool

    return


  toggle_form: ( bool )->
    form = @view.find '.form'

    return unless form.length > 0

    button = form.find '.button'

    inputs = form.find 'input.input'
    inputs.each ->
      q = $ this
      if bool
        q.attr 'id', q.data 'id' if q.data 'id'
      else
        q.data 'id', q.attr 'id'
        q.removeAttr 'id'
      return

    if bool
      button.prop disabled: true
      setTimeout ( -> 
        button.prop disabled: false 
        form.find('input.string').eq(0).focus()
      ), 300

    return
