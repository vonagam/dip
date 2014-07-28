@side = @game.side_of current_user

json.game do
  json.partial! 'games/game', game: @game
  json.chat_is_public @game.chat_is_public?
  json.partial! 'sides/index', sides: @game.sides
  json.partial! 'states/index', game: @game.states
  json.partial! 'messages/index', game: @game, side: @side, offset: nil
  json.map do
    json.partial! 'maps/map', map: @game.map
  end

  json.orders @side && order = @game.order_of(@side)
end


json.partial! 'layouts/access'
