###* @jsx React.DOM ###



each = ( object, fun )->
  if $.isArray object
    for element in object
      return if false == fun element
  else
    fun object
  return



g.view.isSelectable = ( name, control )->
  result = 
    'data-selected': null
    'data-selectable': null
    'onMouseDown': null

  if control.selecting
    for type, data of control.select
      if data.selectable.indexOf( name ) != -1
        result['data-selectable'] = [control.step, type].join ' ' 
        result['onMouseDown'] = data.callback.bind this, name

    for type, data of control.selected
      each data, ( unit )->
        if unit.area.name == name
          result['data-selected'] = type
          return false
        return

  result



g.view.Orders = React.createClass

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
      when 'Move' then Orders.Move.unit
      when 'Retreat' then Orders.Retreat.dislodged
      when 'Supply' then Orders.Supply.supply

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
