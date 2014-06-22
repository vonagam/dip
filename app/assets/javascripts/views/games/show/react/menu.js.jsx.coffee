###* @jsx React.DOM ###

Button = vr.Button
Component = vr.Component



vr.Menu = React.createClass
  render: ->
    game = @props.game
    page = @props.page

    `<div className='menu container row'>
      <div className='left'>
        <Rollback game={game} page={page} />
        <Delete game={game} />
        <Start game={game} />
        <History game={game} page={page} />
        <Timer game={game} />
        <Manual game={game} />
        <SendOrders game={game} page={page} />
      </div>
      <div className='right'>
        <Player game={game} />
        <LinkToRoot />
      </div>
    </div>`



renderButtonComponent = ( 
    className,
    is_active,
    button_options  
  )->
    ->
      game = @props.game

      active = is_active game

      button = Button button_options.call this, game if active

      `<Component className={className} active={active}>
        {button}
      </Component>`



Rollback = React.createClass
  componentDidMount: ()->
    node = $ @getDOMNode()
    node.on 'ajax:success', ( e, data )=>
      page = @props.page
      page.setState page.state_from_data data
      return
    return
  render: renderButtonComponent(
      'rollback'
      ( game )->
        game.user_side?.creator &&
        game.data.status == 'going' && 
        game.states.length > 1 && 
        game.data.sides.length == 1
      ( game )->
        href: Routes.rollback_game_path game.data.id, format: 'json'
        className: 'red'
        method: 'post'
        remote: true
        text: 'rollback'
    )



Delete = React.createClass
  render: renderButtonComponent(
      'delete'
      ( game )->
        game.user_side?.creator &&
        ( 
          switch game.data.status
            when 'waiting' then true
            when 'going'
              game.data.time_mode == 'manual' || 
              game.states[ game.states.length - 1 ].raw.end_at == null
        )
      ( game )->
        href: Routes.game_path game.data.id, format: 'json'
        className: 'red'
        method: 'delete'
        remote: true
        confirm: 'Are you sure?'
        text: 'delete'
    )



Start = React.createClass
  render: renderButtonComponent(
      'start'
      ( game )-> game.user_side?.creator && game.data.status == 'waiting'
      ( game )->
        href: Routes.progress_game_path game.data.id, format: 'json'
        className: 'green'
        method: 'post'
        remote: true
        text: 'start'
    )



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



Timer = React.createClass
  toggle_timer: ( bool )->
    if bool
      @end_at = Date.parse @last.raw.end_at
      return if @timer_id || @end_at <= new Date().getTime()
      @forceUpdate()
      @timer_id = setInterval (=> @forceUpdate()), 1000
    else 
      if @timer_id
        clearInterval @timer_id
        @timer_id = null
    return
  show_remain: ->
    remain = @end_at - new Date().getTime()

    if remain < 0
      @toggle_timer false
      minutes = 0
      seconds = 0
    else
      minutes = Math.floor(remain / 60000)
      seconds = Math.floor( (remain - minutes*60000)/1000 )
    
    "#{ if minutes > 0 then minutes + ':' else ''}#{seconds}"
  componentDidUpdate: -> @toggle_timer @active
  componentDidMount: -> @toggle_timer @active
  render: ->
    game = @props.game
    @last = game.states[ game.states.length - 1 ]

    @active = 
      game.data.status == 'going' && 
      game.data.time_mode != 'manual' &&
      @last.raw.end_at != null

    `<Component className='timer' active={this.active && this.timer_id}>
      remain {this.show_remain()}
    </Component>`



Manual = React.createClass
  render: renderButtonComponent(
    'manual'
    ( game )-> 
      game.user_side?.creator &&
      game.data.time_mode == 'manual' && 
      game.data.status == 'going'
    ( game )->
      href: Routes.progress_game_path game.data.id, format: 'json'
      className: 'red'
      method: 'post'
      remote: true
      text: 'progress'
  )



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
  render: renderButtonComponent(
    'order'
    ( game )-> 
      game.data.status == 'going' && 
      game.state.last &&
      game.user_side?.orderable
    ( game )->
      href: Routes.progress_game_path game.data.id, format: 'json'
      className: 'send ' + if game.state.raw.orders then 'green' else 'yellow'
      text: 'send'
      onMouseDown: @onMouseDown
  )



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
  render: renderButtonComponent(
    'root'
    ( game )-> true
    ( game )-> className: 'grey', href: '/', text: 'root'
  )
