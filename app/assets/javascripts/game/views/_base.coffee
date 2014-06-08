class view.Base extends state.Base
  constructor: ( @game, component_class )->
    super()
    @game.views.push this
    @view = g.page.find ".#{component_class}.j_component"
    @toggls.view = target: @view, class: 'active'


  update_status: ->
    @turn @is_active()
    return


  find: ( selector )->
    @view.find selector
