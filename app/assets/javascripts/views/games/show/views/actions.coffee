class g.view._Actions extends state.Family
  constructor:( views ) ->
    super()

    @view = g.page.find '.actions.j_component'

    @toggls.add Status: target: @view, addClass: 'active'

    for name in [ 'start', 'delete', 'participation' ]
      view = views[ name ]
      @add [ view ] if view
