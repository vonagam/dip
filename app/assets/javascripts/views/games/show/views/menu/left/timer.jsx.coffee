###* @jsx React.DOM ###

g.view.Timer = React.createClass
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
    Component = vr.Component

    game = @props.game
    @last = game.states[ game.states.length - 1 ]

    @active = 
      game.data.status == 'going' && 
      game.data.time_mode != 'manual' &&
      @last.raw.end_at != null

    `<Component className='timer' active={this.active && this.timer_id}>
      remain {this.show_remain()}
    </Component>`
