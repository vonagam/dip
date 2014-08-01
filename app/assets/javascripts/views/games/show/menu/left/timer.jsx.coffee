###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Timer',
  [ 'vr.Component' ]
  ( Component )->

    React.createClass
      toggle_timer: ( bool )->
        if bool
          return if @timer_id || @timer_at <= new Date().getTime()
          @forceUpdate()
          @timer_id = setInterval (=> @forceUpdate()), 1000
        else 
          if @timer_id
            clearInterval @timer_id
            @timer_id = null
        return
      show_remain: ->
        remain = @timer_at - new Date().getTime()

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
        @timer_at = game.timer_at && Date.parse game.timer_at

        @active = 
          game.status == 'going' && 
          game.time_mode != 'manual' &&
          game.timer_at != null

        `<Component className='timer' active={this.active && this.timer_id}>
          remain {this.show_remain()}
        </Component>`
