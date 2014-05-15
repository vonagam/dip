###
togglers = []
power_stats = {}

class BuildArea
  constructor: ( area, @power )->
    @view = area.view()

    @listener = =>
      q = $ @view
      model = q.data 'model'
      current = q.data 'build'
      subs = q.children '[id]'

      return @set_unit 1 if !current && power_stats[@power]

      return @set_unit 0 if model.type == 'land'

      return @set_unit( (current + 1)%3 ) if subs.length == 0

      return @set_unit 0 if current - 1 == subs.length

      return @set_unit (current + 1), subs.eq(current - 1)

    @view
    .attr 'build', true
    .on 'mousedown', @listener

  turn_off: ->
    @view
    .removeAttr 'build'
    .off 'mousedown', @listener
    .data 'build', null

    @remove_unit()
        
  remove_unit: ->
    @view.find('.builded').remove()

  set_unit: (counter, place)->
    @view.data 'build', counter

    @remove_unit()
    return if counter == 0

    coords = ( place || @view ).data 'coords'
    type = if counter == 1 then 'army' else 'fleet'
    place_unit type, coords

  place_unit: ( type, coords )->
    force = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
    force.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#'+type

    force = $(force)

    force.attr
      'class': "builded #{@power.name}"
      'transform': "translate(#{@coords.x},#{@coords.y})"
    
    force.appendTo @area.views.xc



class Actions extends state.Base
  toggle: (bool)->
    return true if super

    power_stats = {}

    if bool
      map = g.map_model
      state = map.state

      for power, data of state.powers
        info = { supplies: data.supplies(), units: data.units }

        info.surplus = info.supplies.size - info.units.size

        power_stats[power] = { supplies: info.supplies.size, units: info.units.size }

        continue if info.supplies.size == info.units.size

        if info.surplus > 0
          for supply in info.supplies
            continue if supply.unit
            togglers.push new BuildArea( supply, power )

        else
          for unit in info.units
            #click to disband

    else
      toggler.turn_off for toggler in togglers
    return

# order loop
g.supply_state = new state.Base

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
###
