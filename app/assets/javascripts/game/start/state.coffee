g.state = undefined

g.change_state = ( new_state )->
  @state.turn 'off' if @state
  @state = new_state
  @state.turn 'on'  if @state
