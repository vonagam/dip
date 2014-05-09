module GamesHelper
  def g_initialize( game, user )
    result = [ "'#{game.status}'" ]

    state = game.state
    result.push "'#{state.type}'", state.data

    if side = game.user_side( user )
      result.push "'#{side.name}'", ( side.order ? side.order.data : 'false' )
    else
      result.push 'false', 'false'
    end

    return result.join ','
  end
end
