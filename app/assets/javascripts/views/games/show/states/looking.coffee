class Looking extends state.Base
  constructor: ->
    super
    @resets.view = '.old_order.j_component'
    @toggls.ordered = 
      target: => @ordered_areas
      bind:
        mouseenter: (e)=> @show_order_string(e)
        mouseleave: => @clear_view()


  toggle_toggls: (bool)->
    if bool
      @get_ordered_areas()
    else
      @ordered_areas.data 'order_string', null

    super

    return


  get_ordered_areas: ->
    @ordered_areas = $()

    check = (q)=>
      area = q.data 'model'

      order = @get_order( area, 'unit' ) || @get_order( area, 'dislodged' )

      if order
        q.data 'order_string', order.to_string()
        @ordered_areas = @ordered_areas.add q

    g.areas.each ->
      check $ this
      return


  get_order: ( area, unit_status )->
    area[unit_status] && area[unit_status].order


  show_order_string: (e)->
    @view.html $(e.target).closest('g').data 'order_string'
    return


  clear_view: ->
    @view.empty()
    return



g.game_phase.Looking = new Looking

g.main_state.add [ g.game_phase.Looking ]
