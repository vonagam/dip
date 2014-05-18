module GamesHelper
  def g_initialize( game, side )
    result = [ "'#{game.status}'" ]

    state = game.state
    result.push "'#{state.type}'", state.data.to_json

    if side
      result.push "'#{side.power}'", ( side.order ? side.order.data.to_json : 'false' )
    else
      result.push 'false', 'false'
    end

    return result.join ','
  end
end
