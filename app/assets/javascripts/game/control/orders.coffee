# index contain loop and order type selection
g.order_index = new klass.StateUnited 
  toggls: 
    game:
      target: -> g.container
      class: 'order_index'

# order loop
order_loop = new klass.StateListLooped

# first - select force to which order will be
force_select = new g.SelectingState
  selecting: -> g.map.find('.force').parent()
  marking: '[force_select]'
  container: -> g.map

# when selected force loose it previous order
class Actions extends klass.StateRadio
  toggle: (bool)->
    return true if super
    if bool
      force = @selected.children('.force')
      if force.data 'order_visualization'
        force.data('order_visualization').remove()
        force.data 'order_visualization', undefined

      @childs[0].turn true 
    return
  after_child_toggled: (child, bool)->
    return true if super
    return if bool == true
    for child in @childs
      return if child.turned == true 
    @turn false
    return

actions = new Actions
  toggls:
    selected:
      target:-> g.map.data '[force_select]'
      attr: 'force_selected'
    probel:
      target:-> doc
      bind: [
        [
          'keydown',
          (e)->
            return support.turn true if e.which == 83
            return move.turn true if e.which == 77
            return actions.turn false if e.which == 32
        ]
      ]

# Move order
move = new klass.StateList
  resets:
    convoy: -> $()

move.after_list_end = ->
    return true unless g.map.data '[move_select]'

    force = g.map.data('[force_select]').children('.force')
    destination = g.map.data('[move_select]')

    if force.data('type') == 'army' && regions[destination.attr('id')]['mv'] == undefined
      @convoy = force.parent() if @convoy.length == 0
      @convoy = @convoy.add destination
      @list_index = 0
      return

    from = force.data('coords')
    to = destination.data('coords')

    return true if from == to

    line = drawMove( from, to )
    line.attr 'class', 'move '+force.data('country')
    g.orders_visualizations.new.append line
    force.data 'order_visualization', line

    return true

move_selecting = ->
  force = g.map.data('[force_select]').children '.force'
  possibles = g.map.find '#'+force.data('where')
  possibles = possibles.add g.map.find('#'+possibility) for possibility in force.data('neighbours')

  if force.data('type') == 'army'
    for typ, neis of regions[force.data('where')]
      continue if typ == 'mv'
      for nei in neis
        continue if regions[nei]['mv'] != undefined
        possibles = possibles.add g.force_places.filter('#'+nei)

  return possibles

convoy_selecting = ->
  last_one = g.map.data('[move_select]').attr('id')
  possibles = $()
  for nei in regions[last_one]['xc']
    nei = nei.split('_')[0]
    if regions[nei]['mv']
      possibles = possibles.add g.map.find('#'+nei)
    else
      possibles = possibles.add g.force_places.filter('#'+nei)
  possibles = possibles.not move.convoy
  return possibles

move_select = new g.SelectingState
  selecting: -> if move.convoy.length > 0 then convoy_selecting() else move_selecting()
  marking: '[move_select]'
  container: -> g.map

# Support order
support = new klass.StateList
support.after_list_end = ->
  return true unless g.map.data '[whom_select]' && g.map.data '[move_select]'

  force = g.map.data('[force_select]').children('.force')
  supporter = force.data('coords')

  from = g.map.data('[whom_select]').children('.force').data('coords')
  to = g.map.data('[move_select]').data('support_coords')

  line = drawSupport( supporter, from, to )
  line.attr 'class', 'support '+force.data('country')
  g.orders_visualizations.new.append line
  force.data 'order_visualization', line

  return true

support_whom_select = new g.SelectingState
  selecting:-> g.map.find('.force').parent().not( g.map.data('[force_select]') )
  marking: '[whom_select]'
  container: -> g.map

support_to_select = new g.SelectingState
  selecting:-> 
    helper = g.map.data('[force_select]').children('.force')
    helped = g.map.data('[whom_select]').children('.force')

    helper_can = $()
    helper_can = helper_can.add g.map.find('#'+nei).closest('g') for nei in helper.data('neighbours')

    helped_can = helped.parent().data 'support_coords', helped.data('coords')
    for nei in helped.data('neighbours')
      helped_can_ = g.map.find('#'+nei)
      helped_can = helped_can.add(
        helped_can_.closest('g').data('support_coords', helped_can_.data('coords'))
      )

    both_can = helper_can.filter helped_can

    if both_can.length == 0
      actions.turn false
      return 42

    if both_can.length == 1
      g.map.data '[move_select]', both_can.eq(0)
      support_to_select.turn false
      return 42

    return both_can
  marking: '[move_select]'
  container: -> g.map
  toggls:
    whom_selected:
      target:-> g.map.data '[whom_select]'
      attr: 'whom_selected'


# Total scheme
g.order_index.add [
  order_loop.add [
    force_select
    actions.add [
      move.add [
        move_select
      ]
    ]
  ]
]

###
support.add [
  support_whom_select,
  support_to_select
]
convoy.add [
  convoy_army.add [
    convoy_army_loop.add [
      convoy_army_select
    ]
  ]
  convoy_fleet.add [
    convoy_fleet_whom_select
    convoy_fleet_to_select
  ]
]
###
