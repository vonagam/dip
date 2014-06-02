class BuildArea
  constructor: ( @area )->
    @view = @area.view()

    @listener = =>
      q = @view
      current = q.data 'build'
      subs = q.children '[id]'

      return @set_unit 1 if !current

      return @set_unit 0 if @area.type() == 'land'

      return @set_unit( (current + 1)%3 ) if subs.length == 0

      return @set_unit 0 if current - 1 == subs.length

      return @set_unit (current + 1), subs.eq(current - 1).attr('id').split('_')[1]

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

    new model.Order.Build( @area, type, sub_area )

    return

class DisbandArea
  constructor: ( @unit )->
    @view = @unit.area.view()

    @listener = =>
      if @unit.order
        @unit.set_order undefined
      else
        g.set_order @unit, 'Disband'

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
g.order_index.add([ g.game_phase.Supply ])
