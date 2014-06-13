# order loop
g.game_phase.Move = new state.ListLooped

# first - select unit to which order will be
unit_select = new g.SelectingState
  selecting: -> g.map.find('.unit').parent()
  marking: '[unit_select]'
  container: -> g.map

# when selected unit loose it previous order
class Actions extends state.Radio
  toggle: (bool)->
    return true if super
    if bool
      @childs[0].turn true 
    return
  after_child_toggled: (child, bool)->
    return true if super
    return if bool == true
    for child in @childs
      return if child.turned == true 

    unit = g.get_unit_in(@selected)
    unless unit.order
      g.set_order unit, 'Hold'

    @turn false
    return



actions = new Actions
  toggls:
    selected:
      target:-> g.map.data '[unit_select]'
      attr: 'unit_selected'
    probel:
      target:-> doc
      bind:
        'keydown': (e)->
          return support.turn true if e.which == 83
          return move.turn true if e.which == 77
          return actions.turn false if e.which == 32 || e.which == 27
          return hold() if e.which == 72
          return

    order_type:
      target: '.order_type.j_component'
      class: 'active'
      bind:
        mousedown: 
          '[data-order]': (e)->
            l = {}
            l.q = $ this
            l.fixo = { move: move, support: support }
            l.type = l.q.data 'order'
            if l.state = l.fixo[l.type]
              l.state.turn true
            else
              hold()
            return false
    order_types:
      target: '.order_type.j_component [data-order]'
      bind:
        'choosen:on': ->
          $(this).choosen 'deactive'
          return


# Hold order
hold = ->
  unit = g.get_unit_in g.map.data('[unit_select]')
  g.set_order unit, 'Hold'
  actions.turn false
  return


# Move order
move = new state.List
  resets:
    convoy: undefined
  toggls:
    button:
      target: '.order_type [data-order="move"]'
      trigger: 'choosen'

move.after_list_end = ->
  return true unless g.map.data '[move_select]'

  unit = g.get_unit_in g.map.data('[unit_select]')
  to = g.map.data '[move_select]'

  if unit.area == g.state.get_area to.attr('id')
    g.set_order unit, 'Hold'
    return true 

  if unit.type == 'army' && regions[to.attr('id')].type == 'water'
    @convoy = unit.area.view().get() unless @convoy
    @convoy.push to.get(0)
    @list_index = 0
    return

  if @convoy
    g.set_order unit, 'Move', to: to.attr('id')
    @convoy.shift()
    for fleet_area in @convoy
      fleet = g.get_unit_in $(fleet_area)
      g.set_order fleet, 'Convoy', to: to.attr('id'), from: unit.area.name
  else
    g.set_order unit, 'Move', to: to.attr('id')

  return true

move_selecting = ->
  unit = g.get_unit_in g.map.data('[unit_select]')
  
  possibles = g.map.find '#'+unit.position()

  for possibility in unit.neighbours()
    pos = possibility.split('_')[0]

    if unit.type == 'army'
      if regions[pos].type == 'water'
        continue unless g.contain_unit( pos )
    else
      continue if regions[pos].type == 'land'
      pos = possibility

    possibles = possibles.add g.map.find('#'+pos)

  return possibles

convoy_selecting = ->
  last_one = g.map.data('[move_select]').attr('id')
  possibles = $()
  for nei in regions[last_one].xc
    nei = nei.split('_')[0]
    if regions[nei].type == 'water'
      possibles = possibles.add g.map.find('#'+nei) if g.contain_unit( nei )
    else
      possibles = possibles.add g.map.find('#'+nei)
  possibles = possibles.not $(move.convoy)
  return possibles

move_select = new g.SelectingState
  selecting: -> if move.convoy then convoy_selecting() else move_selecting()
  marking: '[move_select]'
  container: -> g.map

# Support order
support = new state.List
  toggls:
    button:
      target: '.order_type [data-order="support"]'
      trigger: 'choosen'

support.after_list_end = ->
  return true unless g.map.data '[move_select]'

  who = g.get_unit_in g.map.data('[unit_select]')
  whom = g.get_unit_in g.map.data('[move_select]')

  g.set_order who, 'Support', from: whom.area.name, to: whom.order.target.name

  return true

support_select = new g.SelectingState
  selecting:->
    possibles = $()
    unit = g.get_unit_in actions.selected

    for neighbour in unit.neighbours()
      area = g.state.get_area neighbour

      continue unless unit.can_go area.type()

      for from, order of area.targeting
        continue if from == unit.area.name
        possibles = possibles.add g.map.find("##{from}")

    if possibles.length == 0
      move.turn true
      return 42

    return possibles
  marking: '[move_select]'
  container: -> g.map

# Total scheme
g.order_index.add [
  g.game_phase.Move.add [
    unit_select
    actions.add [
      move.add [
        move_select
      ]
      support.add [
        support_select
      ]
    ]
  ]
]
