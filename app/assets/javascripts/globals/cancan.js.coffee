modulejs.define 'cancan', ->

  Abilities =
    game:
      start: (game)->
        game.user_side?.is_creator() && game.status == 'waiting'
      destroy: (game)->
        game.user_side?.is_creator() &&
        ( 
          switch game.status
            when 'waiting' then true
            when 'going'
              game.time_mode == 'manual' || 
              game.states[ game.states.length - 1 ].end_at == null
        )
      progress: (game)->
        game.user_side?.is_creator() &&
        game.time_mode == 'manual' && 
        game.status == 'going'
    message:
      create: (game)->
        switch game.status
          when 'waiting' then true
          when 'going' then game.user_side && game.user_side.status != 'lost'
          when 'ended' then game.user_side
    state:
      destroy: (game)->
        game.user_side?.is_creator() &&
        game.status == 'going' && 
        game.states.length > 1 && 
        game.sides.length == 1
    side:
      create: (game)->
        game.status == 'waiting' && !game.user_side && game.map.powers.length > game.sides.length
      update: (game)->
        game.status == 'waiting' && game.user_side && !game.powers_is_random
      destroy: (game)->
        game.status == 'waiting' && game.user_side && !game.user_side.is_creator()
    order:
      send: (game)->
        game.status == 'going' && 
        game.state.last &&
        game.user_side?.orderable

  (question, data, user)->
    [action, model_name] = question.split ' '

    if model_name == undefined
      model_name = data.model_name

    for name, condition of Abilities[model_name]
      if( 
        if $.isArray(name)
          name.indexOf(action) > -1 
        else
          name == action || name == 'manage'
        )

        answer = condition data, user, action

    Boolean answer
