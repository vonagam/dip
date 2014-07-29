modulejs.define 'm.Game', 
  ['m.Base', 'm.State', 'm.Side']
  (Base, State, Side)->
    class extends Base
      model_name: 'game'

      $set_states: ( key, states, options )->
        delete options[key]

        if @states && states.length >= @states.length
          if states.length > @states.length
            options[@states.length - 1] =
              $merge: states[states.length - 2]
              last: $set: false

            options.$push = new State states[states.length - 1], this, true
          else
            options[@states.length - 1] = $merge: states[states.length - 1]
        else
          options.$set = for state, i in states then new State state, this, i == states.length - 1

        return

      $set_sides: ( key, sides, options )->
        options.$set = for side in sides then new Side side, this
        return

      get_user_side: ( user )->
        for side in @sides
          return side if side.user == user.login
        return null

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
