class BuildArea
  constructor: ( @area )->
    @view = @area.view()

    @listener = =>
      q = @view
      current = q.data 'build'
      subs = q.children '[id]'

      set_to = (=>
        return 1 unless current
        return 0 if @area.type() == 'land'
        return (current + 1)%3 if subs.length == 0
        return 0 if current - 1 == subs.length
        return undefined
      )()

      if set_to != undefined
        @set_unit set_to
      else
        @set_unit (current + 1), subs.eq(current - 1).attr('id').split('_')[1]

      return false 

    @view
    .attr 'build', true
    .on 'mousedown', @listener

  turn_off: ->
    @view
    .removeAttr 'build'
    .off 'mousedown', @listener
    .data 'build', null
    return

  clear_order: ->
    @area.unit.order.remove() if @area.unit
    return

  set_unit: (counter, sub_area)->
    @view.data 'build', counter

    @clear_order()

    return if counter == 0

    type = if counter == 1 then 'army' else 'fleet'

    build = new g.model.Order.Build @area, sub_area, { unit: type }
    build.unit.attach()

    return

class DisbandArea
  constructor: ( @unit )->
    @view = @unit.area.view()

    @listener = =>
      if @unit.order
        @unit.set_order undefined
      else
        g.set_order @unit, 'Disband'
      return false

    @view
    .attr 'disband', true
    .on 'mousedown', @listener

  turn_off: ->
    @view
    .removeAttr 'disband'
    .off 'mousedown', @listener
    return


class SupplyState extends state.Base
  toggle: (bool)->
    return true if super

    if bool
      @order_areas = []
      for power, data of g.state.powers
        units = data.units.filter (u)-> !u.order
        supplies = data.supplies()

        surplus = supplies.length - units.length

        continue if surplus == 0

        if surplus > 0
          for supply in supplies
            continue if supply.unit && !supply.unit.order
            @order_areas.push new BuildArea supply

        else
          for unit in units
            @order_areas.push new DisbandArea unit

    else
      build_area.turn_off() for build_area in @order_areas
      @order_areas = []

    return

# order phase
g.game_phase.Supply = new SupplyState

# Supply scheme
g.main_state.add([ g.game_phase.Supply ])
