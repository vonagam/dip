get_dislodged_in = ( area_view )->
  area_view.children('.dislodged').data('model')

# order loop
g.game_phase.Retreat = new state.ListLooped

# first - select force to which order will be
dislodged_select = new g.SelectingState
  selecting: -> g.map.find('.dislodged').parent()
  marking: '[dislodged_select]'
  container: -> g.map

retreat_select = new g.SelectingState
  selecting: -> 
    unit = get_dislodged_in g.map.data('[dislodged_select]')
  
    possibles = unit.area.view unit.sub_area

    for possibility in unit.neighbours()
      area = g.state.get_area possibility

      if area.embattled || area.unit || area.name == unit.dislodged
        continue

      possibles = possibles.add area.view()

    return possibles
  marking: '[move_select]'
  container: -> g.map

retreat = new state.List
  toggls:
    selected:
      target:-> g.map.data '[dislodged_select]'
      attr: 'dislodged_selected'
    probel:
      target:-> doc
      bind:
        'keydown': (e)->
          if e.which == 27 || e.which == 32
            unit = get_dislodged_in g.map.data('[dislodged_select]')
            unit.set_order undefined
            retreat.turn false
            return

retreat.after_list_end = ->
  return true unless g.map.data '[move_select]'

  unit = get_dislodged_in g.map.data('[dislodged_select]')
  to = g.map.data '[move_select]'

  if unit.area == g.state.get_area to.attr('id')
    unit.set_order undefined
    return true 

  g.set_order unit, 'Retreat', to: to.attr('id')

  return true

# Retreat scheme
g.main_state.add [
  g.game_phase.Retreat.add [
    dislodged_select
    retreat.add [
      retreat_select
    ]
  ]
]
