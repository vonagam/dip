###* @jsx React.DOM ###

Button = vr.Button
Component = vr.Component



vr.Menu = React.createClass
  render: ->
    game = @props.game
    page = @props.page

    `<div className='menu container row'>
      <div className='left'>
        <History game={game} page={page} />
        <Manual game={game} />
        <SendOrders game={game} page={page} />
      </div>
      <div className='right'>
        <Player game={game} />
        <LinkToRoot />
      </div>
    </div>`



History = React.createClass
  controls: ->
    'back all': (x,max)-> 0
    'back one': (x,max)-> x-1
    'forward one': (x,max)-> x+1
    'forward all': (x,max)-> max
  state_label: ( state )->
    year = parseInt state.date / 2
    season = state.date % 2
    "#{year}.#{season}:#{state.type}"
  set_state_by_index: ( index )->
    @props.page.set_state @props.game.states[index]
    return
  onChange: (e)->
    @set_state_by_index e.target.value
    return
  onKeyDown: (e)->
    if e.shiftKey && @active
      @refs['back one'].props.onMouseDown() if e.which == 37
      @refs['forward one'].props.onMouseDown() if e.which == 39
    return
  componentDidMount: ->
    document.addEventListener 'keydown', @onKeyDown
    return
  componentWillUnmount: ->
    document.removeEventListener 'keydown', @onKeyDown
    return
  render: ->
    game = @props.game

    @active = game.data.status != 'waiting'

    if @active
      select_option = vr.Input.select_option
      states = game.states
      
      options = {}
      for state, i in states
        options[state.raw.id] = 
          `<select_option 
            value={i}
            label={this.state_label(state.raw)}
          />`

      controls = {}
      current = states.indexOf game.state
      max = states.length - 1
      for name, fun of @controls()
        move_to = Math.max 0, Math.min max, fun current, max
        control_classes = vr.classes 'control', name, hidden: move_to == current

        controls[name] = 
          `<div 
            ref={name}
            className={control_classes}
            onMouseDown={this.set_state_by_index.bind(this,move_to)}
          >
            <div className='press' />
          </div>`

    `<Component className='history' active={this.active}>
      <select className='input' value={current} onChange={this.onChange}>
        {options}
      </select>
      <div className='controls row'>
        {controls}
      </div>
    </Component>`



Manual = React.createClass
  render: ->
    game = @props.game

    active = 
      game.user_side?.creator &&
      game.data.time_mode == 'manual' && 
      game.data.status == 'going'

    if active
      href = Routes.progress_game_path game.data.id, format: 'json'
      button = 
        `<Button
          className='red'
          href={href} 
          method='post'
          remote={true} 
          text='progress'
        />`

    `<Component className='manual' active={active}>
      {button}
    </Component>`



SendOrders = React.createClass
  onMouseDown: (e)->
    orders = JSON.stringify @props.game.state.collect_orders()

    $(@getDOMNode()).ajax 'post',
      Routes.game_order_path @props.game.data.id, format: 'json'
      order: { data: orders }
      ( order )=>
        state = @props.game.state

        if state.last
          state.raw.orders = order.data
          @props.page.forceUpdate()

        return
    vr.stop_event e
  render: ->
    game = @props.game

    active = 
      game.data.status == 'going' && 
      game.state.last &&
      game.user_side?.orderable

    if active
      button_classes = vr.classes 'send', 
        if game.state.raw.orders then 'green' else 'yellow'

      button = 
        `<Button
          className={button_classes}
          onMouseDown={this.onMouseDown}
          text='send'
        />`

    `<Component className='order' active={active}>
      {button}
    </Component>`



Player = React.createClass
  render: ->
    game = @props.game
    name = game.data.login

    active = name != undefined

    if active
      login = `<div className='login'>{name}</div>`

      if game.user_side
        power = `<div className='power'>{game.user_side.name || 'Random'}</div>`

    className = vr.classes 'player', two_line: power != null

    `<Component className={className} active={active}>
      {login}
      {power}
    </Component>`



LinkToRoot = React.createClass
  render: ->
    `<Component className='' active={true}>
      <Button className='grey' href='/' text='root' />
    </Component>`
