g.get_unit_in = ( area_view )->
  area_view.children('.unit').data('model')

g.contain_unit = ( id )->
  g.map.find("##{id}").children('.unit').length > 0

# index contain loop and order type selection
g.order_index = new state.Radio 
  toggls:
    game:
      target: -> g.container
      class: 'order_index'
    form:
      target: -> doc.find('.order_form button')
      bind:
        'mousedown': ()->
          orders = g.map_model.state.collect_orders g.power

          $(this).closest('form').find('[name="order[data]"]').val( jso(orders) )
