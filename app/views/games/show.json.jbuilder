json.game do
  json.partial! 'games/game', game: @game
  json.chat_is_public @game.chat_is_public?
  json.partial! 'sides/index', sides: @game.sides
  json.partial! 'states/index', game: @game, side: @side
  json.partial! 'messages/index', game: @game, side: @side, offset: nil
  json.map do
    json.partial! 'maps/map', map: @game.map
  end
end


json.partial! 'layouts/access'
