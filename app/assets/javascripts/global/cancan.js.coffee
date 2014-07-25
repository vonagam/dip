modulejs.define 'cancan', ->

  Abilities =
    message:
      create: ( user, game )->
        switch game.status
          when 'waiting' then true
          when 'going' then game.user_side && game.user_side.status != 'lost'
          when 'ended' then game.user_side
    state:
      destroy: ( user, game )->
        game.user_side?.creator &&
        game.status == 'going' && 
        game.states.length > 1 && 
        game.sides.length == 1

  (user, question, model)->
    [action, model_name] = question.split ' '

    for name, condition of Abilities[model_name]
      if( 
        if $.isArray(name)
          name.indexOf(action) > -1 
        else
          name == action || name == 'manage'
        )

        answer = condition user, model, action

    Boolean answer
