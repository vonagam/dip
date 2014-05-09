order_to_json = ( order )->
  result = { type: order.type }

  if result.type == 'hold'
    return result

  if result.type == 'move'
    result.to = order.position.attr('id')
    return result

  if result.type == 'support' || result.type == 'convoy'
    whom = order.whom
    result.from = whom.data 'where'

    whom_order = whom.data 'order'
    if whom_order.type == 'move'
      result.to = whom_order.position.attr('id')
    else
      result.to = result.from

    return result


# index contain loop and order type selection
g.order_index = new klass.StateUnited 
  toggls:
    game:
      target: -> g.container
      class: 'order_index'
    form:
      target: -> doc.find('#new_order button')
      bind:
        'mousedown': ()->
          orders = {}

          g.forces.each ()->
            q = $ this
            if q.data('country') == g.country
              orders[ q.data('where') ] = order_to_json( q.data('order') )

          log( jso(orders) )

          $(this).closest('form').find('[name="order[data]"]').val( jso(orders) )


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
      force = @selected.children '.force'

      @childs[0].turn true 
    return
  after_child_toggled: (child, bool)->
    return true if super
    return if bool == true
    for child in @childs
      return if child.turned == true 

    unless @selected.children('.force').data('order')
      g.make.order 'hold', @selected.children('.force')

    @turn false
    return

actions = new Actions
  toggls:
    selected:
      target:-> g.map.data '[force_select]'
      attr: 'force_selected'
    probel:
      target:-> doc
      bind:
        'keydown': (e)->
          return support.turn true if e.which == 83
          return move.turn true if e.which == 77
          return actions.turn false if e.which == 32

          if e.which == 72
            g.make.order 'hold', g.map.data('[force_select]').children('.force')
            actions.turn false
            return

# Move order
move = new klass.StateList
  resets:
    convoy: undefined

move.after_list_end = ->
  return true unless g.map.data '[move_select]'

  force = g.map.data('[force_select]').children '.force'
  destination = g.map.data '[move_select]'

  if force.data('where') == destination.attr('id')
    g.make.order 'hold', force
    return true 

  if force.data('type') == 'army' && regions[destination.attr('id')].type == 'water'
    @convoy = force.parent().get() unless @convoy
    @convoy.push destination.get(0)
    @list_index = 0
    return

  if @convoy
    @convoy.push destination.get(0)
    g.make.order 'convoy', force, @convoy
  else
    g.make.order 'move', force, destination

  return true

move_selecting = ->
  force = g.map.data('[force_select]').children '.force'
  
  possibles = g.map.find '#'+force.data('where')

  for possibility in force.data 'neighbours'
    pos = possibility.split('_')[0]

    if force.data('type') == 'army'
      if regions[pos].type == 'water'
        continue if g.force_places.filter('#'+pos).length == 0
    else
      continue if regions[pos].type == 'land'
      pos = possibility

    possibles = possibles.add g.map.find('#'+pos)

  return possibles

convoy_selecting = ->
  last_one = g.map.data('[move_select]').attr('id')
  possibles = $()
  for nei in regions[last_one].neis
    nei = nei.split('_')[0]
    if regions[nei].type == 'water'
      possibles = possibles.add g.force_places.filter('#'+nei)
    else
      possibles = possibles.add g.map.find('#'+nei)
  possibles = possibles.not $(move.convoy)
  return possibles

move_select = new g.SelectingState
  selecting: -> if move.convoy then convoy_selecting() else move_selecting()
  marking: '[move_select]'
  container: -> g.map

# Support order
support = new klass.StateList
support.after_list_end = ->
  return true unless g.map.data '[move_select]'

  who = g.map.data('[force_select]').children('.force')
  whom = g.map.data('[move_select]').children('.force')

  g.make.order 'support', who, whom

  return true

support_select = new g.SelectingState
  selecting:-> 
    possibles = $()
    force = actions.selected.children '.force'
    for neighbour in force.data 'neighbours'
      for where, who of g.map.find('#'+neighbour.split('_')[0]).data('targeting')
        continue if who[0] == force[0]
        possibles = possibles.add who.parent()

    if possibles.length == 0
      move.turn true
      return 42

    return possibles
  marking: '[move_select]'
  container: -> g.map

# Total scheme
g.order_index.add [
  order_loop.add [
    force_select
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
