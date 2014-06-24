###* @jsx React.DOM ###



vr.isSelectable = ( name, control )->
  if control.selecting
    for name, data of control.select
      if data.selectable.indexOf( name ) != -1
        return {
          'data-selectable': control.step 
          'onMouseDown': data.callback.bind this, name
        }

  'data-selectable': null, 'onMouseDown': null



vr.Orders = React.createClass

  getInitialState: ->
    selecting: false

  empty_state: ->
    selecting: false
    selected: null
    select: null
    step: null

  changeSelecting: ( selecting, args... )->
    @setState @getSelect selecting, args

  getSelect: ( selecting, args )->
    selecting.apply this, args

  getFirstSelecting: ( game )->
    switch game.state.type()
      when 'Move' then Orders.Move.unit
      when 'Retreat' then Orders.Retreat.unit
      when 'Supply' then Orders.Supply.unit

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
          @empty_state()
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
      $.extend { control: @state }, child.props
    )
