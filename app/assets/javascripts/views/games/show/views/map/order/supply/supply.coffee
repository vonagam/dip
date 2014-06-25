modulejs.define 'g.v.map.order.supply.supply', 
  [ 'g.m.order.Build' ]
  ( Build )->

    set_build = ( area, possible )->
      new Build area, possible.sub, { unit: possible.type }
      return

    build_callback = ( name )->
      area = @gstate.get_area name
      unit = area.unit
      possible = area.possible_builds()

      if !unit
        set_build area, possible[0]
      else
        unit.order.remove()

        index = possible.indexOf possible.filter( (p)->
          p.sub == unit.sub_area && p.type == unit.type
        )[0]

        set_build area, possible[ index + 1 ] if index + 1 < possible.length

      @changeSelecting supply_selecting
      return

    disband_callback = ( name )->
      unit = @gstate.get_area( name ).unit

      if unit.order
        unit.set_order null
      else
        unit.create_order 'Disband'

      @changeSelecting supply_selecting
      return

    supply_selecting = ->
      select =
        build: { selectable: [], callback: build_callback.bind(@) }
        disband: { selectable: [], callback: disband_callback.bind(@) }

      for name, power of @gstate.powers
        all_units = power.units
        real_units = all_units.filter (unit)-> !unit.order
        supplies = power.supplies()

        if supplies.length - real_units.length > 0
          for supply in supplies
            continue if supply.unit && !supply.unit.order

            if supply.unit || all_units.length < supplies.length
              select.build.selectable.push supply.name

        if supplies.length - all_units.length < 0
          for unit in all_units
            if unit.order || real_units.length > supplies.length
              select.disband.selectable.push unit.area.name

      step: 'supply'
      selected: null
      select: select

    supply_selecting
