modulejs.define 'm.Game', 
  ['m.Base', 'm.State', 'm.Side']
  (Base, State, Side)->
    class extends Base
      model_name: 'game'

      constructor: ( options, @user )->
        super options

      $set_states: ( key, states, options, all )->
        delete options[key]

        if @states && states.length >= @states.length
          if states.length > @states.length
            new_state = new State states[states.length-1], this, true

            options[@states.length-1] =
              $merge: states[states.length-2]
              orders: $set: new_state.orders_info
              last: $set: false

            options.$push = [new_state]
          else
            options[@states.length-1] = $merge: states[states.length-1]
        else
          new_states = for state, i in states then new State state, this, i+1 == states.length
          for state, i in new_states
            if i+1 < new_states.length
              state.orders = new_states[i+1].orders_info
          options.$set = new_states
          all.state = $set: new_states[new_states.length-1].read_data()

        return

      $set_sides: ( key, sides, options, all )->
        new_sides = for side in sides then new Side side, this
        user_side = null
        for side in new_sides
          if side.user == @user.login
            user_side = side
            break

        options.$set = new_sides
        all.user_side = $set: user_side
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
