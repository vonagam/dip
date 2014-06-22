class g.model.Game
  constructor: ( data )->
    @id = data.id
    @update data


  update: ( data )->
    @data = data
    @side = @get_user_side()
    @status = data.status

    if @states && data.states.length >= @states.length
      if data.states.length > @states.length
        @last.raw = data.states[ data.states.length - 2 ]
        @last.last = false

        @last = new g.model.State data.states[ data.states.length - 1 ], this
        @last.last = true

        @states.push @last
      else
        @last.raw = data.states[ data.states.length - 1 ]
    else
      @states = for state in data.states then new g.model.State state, this
      @last = @states[@states.length - 1]
      @last.last = true

    @length = @states.length - 1


  get_user_side: ->
    for side in @data.sides
      return side if side.user_side
    return null


  is_left: ->
    return false if @data.time_mode == 'manual' || @states.length < 4
    @last.raw.end_at == null
