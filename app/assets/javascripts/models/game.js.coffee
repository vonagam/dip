modulejs.define 'm.Game', 
  ['m.Base', 'm.State', 'm.Side']
  (Base, State, Side)->
    class extends Base
      name: 'game'
      attrs: [
        'id'
        'created_at'
        'name'
        'slug'
        'status'
        'ended_by'
        'is_public'
        'chat_mode'
        'time_mode'
        'powers_is_random'
        'map'
        'map_name'
        'creator'
        'sides'
        'sides_count'
        'states'
        'states_count'
        'messages'
        'chat_is_public'
      ]

      set_states: ( states )->
        if @states && states.length >= @states.length
          if states.length > @states.length
            @last.set states[states.length - 2]
            @last.last = false

            @last = new State states[states.length - 1], game: this
            @last.last = true

            @states.push @last
          else
            @last.set states[states.length - 1]
        else
          @states = for state in states then new State state, game: this
          @last = @states[@states.length - 1]
          @last.last = true
          @state = @last

        @state.read_data()
        @states_count = @states.length
        return

      set_sides: ( sides )->
        @sides = for side in sides then new Side side, game: this
        @set_user login: @user_side.user if @user_side
        return

      set_user: ( user )->
        for side in @sides
          if side.user == user.login
            @user_side = side 
            return
        @user_side = null
        return

      private_chat_is_available: ->
        @status == 'going' && !@chat_is_public

      taken_powers: ->
        @sides.reduce (taken, side)->
          if side.power then taken.concat(side.power) else taken
        , []

      available_powers: ->
        powers = @map.powers
        taken = @taken_powers()
        powers.filter (power)-> taken.indexOf(power) == -1
