class g.view.Base extends BP.View
  constructor: ( @game, @component_class, permanent = false )->
    super @game, @component_class, ".#{@component_class}.j_component"

    @toggls.add Status: target: @view, addClass: 'active'
    
    @turn true if permanent


  update_status: ->
    @turn @is_active()
    return
