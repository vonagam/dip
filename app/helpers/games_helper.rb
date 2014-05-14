module GamesHelper
  def g_initialize( game, user )
    result = [ "'#{game.status}'" ]

    state = game.state
    result.push "'#{state.type}'", state.data

    if side = game.side_of( user )
      result.push "'#{side.power}'", ( side.order ? side.order.data : 'false' )
    else
      result.push 'false', 'false'
    end

    return result.join ','
  end
end
