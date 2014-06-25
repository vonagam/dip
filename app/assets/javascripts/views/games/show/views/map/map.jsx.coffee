###* @jsx React.DOM ###

g.view.Map = React.createClass
  getInitialState: ->
    hide_abbrs: $.cookie('hide_abbrs') == 'true'
  toggleAbbrs: ->
    hide = !@state.hide_abbrs
    @setState hide_abbrs: hide
    $.cookie 'hide_abbrs', hide
    return
  stopClick: (e)->
    vr.stop_event e if e.button == 0
    return
  render: ->
    SvgMap = g.view.SvgMap
    Stats = g.view.Stats
    AbbrToggler = g.view.AbbrToggler
    ChooseOrder = g.view.ChooseOrder

    className = vr.classes 'map_container container', hide_abbrs: @state.hide_abbrs

    game_state = @props.game.state

    `<div className={className} onMouseDown={this.stopClick}>
      <SvgMap 
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
