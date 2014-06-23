###* @jsx React.DOM ###



ChekOrderControl = ( name, order_control )->
  if order_control && order_control[0].indexOf(name) != -1
    'data-selectable': true, 'onMouseDown': order_control[1].bind this, name
  else
    'data-selectable': null, 'onMouseDown': null



vr.Orders = React.createClass
  getInitialState: ->
    selecting: false
    selectable: []
    selected: null
    callback: null

  changeSelecting: ( callback, args... )->
    @setState callback.apply this, args






Orders =
  Move:
    unit: ->
      state = @props.game.state

      selectable = [] 
      for name, power of state.powers
        for unit in power.units
          selectable.push unit.area.name

      callback = ( name )=>
        area = state.get_area name
        unit = area.unit

        @changeSelecting Orders.Move.move, unit
        return

      selected: null
      selectable: selectable
      callback: callback

    hold: ( unit )->
      g.set_order unit, 'Hold'
      Order.Move.unit.apply this

    move: ( unit )->
      state = @props.game.state

      if unit.type == 'army'
        selectable = []

        for nei_name in unit.area.neighbours()
          nei_area = state.get_area nei_name
          continue if nei_area.type() == 'water' && !nei_area.unit
          selectable.push nei_name

      else
        selectable = unit.neighbours()

      callback = ( name )=>
        target = state.get_area name

        if unit.can_go target.type()
          if target == unit.area
            g.set_order unit, 'Hold'
          else
            g.set_order unit, 'Move', to: name

          @changeSelecting Orders.Move.unit
        else
          if unit.type == 'army' && target.type() == 'water'
            fleet = target.unit
            @changeSelecting Orders.Move.convoy, unit, [fleet]

        return

      selected: unit
      selectable: selectable
      callback: callback

    convoy: ( army, fleets )->
      state = @props.game.state

      last = fleets[0]

      selectable = []

      for possibility in last.area.neighbours()
        pos_area = state.get_area possibility

        if pos_area.type() != 'water' || pos_area.unit
          selectable.push pos_area.name

      units_areas = fleets.concat( army ).map (unit)-> unit.area.name

      selectable = selectable.filter (area_name)->
        units_areas.indexOf(area_name) == -1

      callback = ( name )=>
        target = state.get_area name

        if target.type() == 'water'
          @changeSelecting Orders.Move.convoy, army, fleets.concat target.unit
        else
          g.set_order army, 'Move', to: name

          for fleet in fleets
            g.set_order fleet, 'Convoy', to: name, from: army.area.name

          @changeSelecting Orders.Move.unit
        
        return

      selected: army
      selectable: selectable
      callback: callback

    support: ( unit )->
      state = @props.game.state

      selectable = []

      for neighbour in unit.neighbours()
        area = state.get_area neighbour

        for from, order of area.targeting
          continue if from == unit.area.name
          selectable.push area.name

      if selectable.length == 0
        return Order.Move.move.call this, unit

      callback = ( name )=>
        area = state.get_area name
        supported = area.unit

        g.set_order unit, 'Support', from: name, to: supported.order.target.name

        @changeSelecting Orders.Move.unit
        return

      selected: unit
      selectable: selectable
      callback: callback

