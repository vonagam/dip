class klass.Map
  constructor: ( regions )->
    @state = undefined
    @show_orders = true

    @areas = {}
    for name, data of regions
      @areas[name] = new klass.Area this, name, data

  set_state: ( state )->
    @state.detach() if @state
    @state = state
    if @state
      @state.attach()
      @state.toggle_orders @show_orders
    return

  toggle_orders: ( bool )->
    return if @show_orders == bool
    @state.toggle_orders bool if @state
    @show_orders = bool
    return
