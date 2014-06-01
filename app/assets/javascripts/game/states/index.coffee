g.get_unit_in = ( area_view )->
  area_view.children('.unit').data('model')

g.contain_unit = ( area_name )->
  g.state.areas[ area_name ].unit

g.game_phase = {}

g.order_index = new state.Radio 
  toggls:
    form:
      target: -> doc.find('#new_order button')
      bind:
        'mousedown': ()->
          orders = g.state.collect_orders g.power

          $(this).closest('form').find('[name="order[data]"]').val( jso(orders) )
