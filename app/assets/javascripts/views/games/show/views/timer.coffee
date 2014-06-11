class g.view.Timer extends g.view.Base
  constructor: ( game, data )->
    if data.time_mode != 'manual'
      super game, 'timer'

      @time_place = @find '.remain'
      @timer_id = null
      @time = null


  is_active: ->
    @game.status == 'started' && !@game.is_left


  update: ( game_updated )->
    return unless game_updated

    @update_status()

    clearInterval @timer_id

    if @turned

      @time = Date.parse @game.last.raw.end_at

      @show_remain()

      @timer_id = setInterval => 
        @show_remain()
      , 1000

    return


  show_remain: ->
    remain = @time - new Date().getTime()

    if remain < 0
      clearInterval @timer_id
      minutes = 0
      seconds = 0
    else
      minutes = Math.floor(remain / 60000)
      seconds = Math.floor( (remain - minutes*60000)/1000 )
    
    @time_place.html "#{ if minutes > 0 then minutes + ':' else ''}#{seconds}"
    return


  turn: ( bool )->
    super

    if bool == false
      clearInterval @timer_id
