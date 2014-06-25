###* @jsx React.DOM ###

modulejs.define 'g.v.map.Order',
  [ 
    'g.v.map.order.move.unit'
    'g.v.map.order.retreat.dislodged'
    'g.v.map.order.supply.supply'
  ]
  ( move_unit, retreat_dislodged, supply_supply )->

    React.createClass

      getInitialState: ->
        selecting: false

      empty_state:
        selecting: false
        selected: null
        select: null
        step: null

      changeSelecting: ( selecting, args... )->
        @setState @getSelect selecting, args

      changeOrder: ( selecting )->
        @changeSelecting selecting, @state.selected
        return

      getSelect: ( selecting, args )->
        selecting.apply this, args

      getFirstSelecting: ( game )->
        switch game.state.type()
          when 'Move' then move_unit
          when 'Retreat' then retreat_dislodged
          when 'Supply' then supply_supply

      getFirstSelect: ( game )->
        $.extend { selecting: true }, @getSelect @getFirstSelecting game

      ordersIsPossible: ( game )->
        game.data.status == 'going' && game.state.last

      update: ( props )->
        game = props.game
        is_possible = @ordersIsPossible game
        @gstate = game.state

        if @state.selecting != is_possible
          @setState(
            if is_possible
              @getFirstSelect game
            else
              @empty_state
          )

        return

      componentWillReceiveProps: ( next_props )->
        @update next_props
        return

      componentWillMount: ->
        @update @props
        return

      render: ->
        child = @props.children

        child.constructor.ConvenienceConstructor(
          $.extend { control: @state, changeOrder: @changeOrder }, child.props
        )
