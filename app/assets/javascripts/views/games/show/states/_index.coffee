g.get_unit_in = ( area_view )->
  area_view.children('.unit').data('model')

g.contain_unit = ( area_name )->
  g.state.areas[ area_name ].unit

g.game_phase = {}

g.main_state = new state.Radio
