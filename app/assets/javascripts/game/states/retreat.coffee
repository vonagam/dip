get_dislodged_in = ( area_view )->
  area_view.children('.dislodged').data('model')

# order loop
g.retreat_state = new state.ListLooped

# first - select force to which order will be
dislodged_select = new g.SelectingState
  selecting: -> g.map.find('.dislodged').parent()
  marking: '[dislodged_select]'
  container: -> g.map

retreat_select = new g.SelectingState
  selecting: -> 
    unit = get_dislodged_in g.map.data('[dislodged_select]')
  
    possibles = g.map.find '#'+unit.get_full_position()

    for possibility in unit.neighbours()
      pos = possibility.split('_')[0]

      area = g.map_model.areas[pos]

      if area.is_embattled || area.unit || area.name == unit.dislodged
        continue

      possibles = possibles.add g.map.find('#'+pos)

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

  if unit.area.name == to.attr('id').split('_')[0]
    unit.set_order undefined
    return true 

  g.set_order unit, 'Retreat', to: to.attr('id')

  return true

# Retreat scheme
g.order_index.add [
  g.retreat_state.add [
    dislodged_select
    retreat.add [
      retreat_select
    ]
  ]
]