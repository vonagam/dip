class view.Base extends state.Base
  constructor: ( @game, @component_class, permanent = false )->
    super()
    @game.views.push this
    @view = g.page.find ".#{@component_class}.j_component"
    @toggls.status = target: @view, class: 'active'
    @turn true if permanent


  update_status: ->
    @turn @is_active()
    return


  find: ( selector )->
    @view.find selector

