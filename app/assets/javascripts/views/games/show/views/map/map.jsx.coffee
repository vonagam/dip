###* @jsx React.DOM ###

modulejs.define 'g.v.Map', 
  [ 
    'g.v.map.Svg'
    'g.v.map.Stats'
    'g.v.map.AbbrToggler'
    'g.v.map.ChooseOrder'
    'vr.classes'
    'vr.stopEvent'
  ]
  (
    Svg
    Stats
    AbbrToggler
    ChooseOrder
    classes
    stopEvent 
  )->

    React.createClass
      getInitialState: ->
        hide_abbrs: $.cookie('hide_abbrs') == 'true'
      toggleAbbrs: ->
        hide = !@state.hide_abbrs
        @setState hide_abbrs: hide
        $.cookie 'hide_abbrs', hide
        return
      stopClick: (e)->
        stopEvent e if e.button == 0
        return
      render: ->
        className = classes 'map_container container', hide_abbrs: @state.hide_abbrs

        game_state = @props.game.state

        `<div className={className} onMouseDown={this.stopClick}>
          <Svg
            state={game_state} 
            coords={this.props.coords} 
            control={this.props.control} 
          />
          <Stats 
            state={game_state} 
          />
          <AbbrToggler 
            hide_abbrs={this.state.hide_abbrs} 
            callback={this.toggleAbbrs} 
          />
          <ChooseOrder 
            state={game_state} 
            control={this.props.control} 
            changeOrder={this.props.changeOrder} 
          />
        </div>`

###
TODO
.old_order.j_component
###
