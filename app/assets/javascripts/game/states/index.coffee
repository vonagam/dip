g.get_unit_in = ( area_view )->
  area_view.children('.unit').data('model')

g.contain_unit = ( area_name )->
  g.state.areas[ area_name ].unit

g.game_phase = {}

g.order_index = new state.Radio 
  toggls:
    game:
      target: -> g.container
      class: 'order_index'
    form:
      target: -> doc.find('.order_form button')
      bind:
        'mousedown': ()->
          orders = g.state.collect_orders g.power

          $(this).closest('form').find('[name="order[data]"]').val( jso(orders) )
