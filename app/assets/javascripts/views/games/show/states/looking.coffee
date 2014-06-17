class Looking extends state.Base
  constructor: ->
    super
    @resets.view = '.old_order.j_component'
    @toggls.add
      Ordered:
        target: @get_ordered_areas
        on:
          mouseenter: @show_order_string
          mouseleave: @clear_view
        addData: 
          order_string: ( q )-> @get_area_order( q.data 'model' ).to_string()


  get_ordered_areas: ->
    g.areas.filter ( i, element )=> @get_area_order $(element).data 'model'


  get_area_order: ( area )->
    @get_unit_order( area, 'unit' ) || @get_unit_order( area, 'dislodged' )


  get_unit_order: ( area, unit_status )->
    area[unit_status] && area[unit_status].order


  show_order_string: (e)->
    @view.html $(e.target).closest('g').data 'order_string'
    return


  clear_view: ->
    @view.empty()
    return



g.game_phase.Looking = new Looking

g.main_state.add [ g.game_phase.Looking ]
