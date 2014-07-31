@side = @game.side_of current_user

json.game do
  json.partial! 'games/game', game: @game
  json.chat_is_public @game.chat_is_public?
  json.partial! 'sides/index', sides: @game.sides
  json.partial! 'states/index', states: @game.states
  json.partial! 'messages/index', game: @game, side: @side, offset: nil
  json.map do
    json.partial! 'maps/map', map: @game.map
  end

  json.orders @side && @game.order_of(@side).try(:data)
end


json.partial! 'layouts/access'
