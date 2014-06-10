games = Game.where( is_public: true ).to_a

if user_signed_in?
  json.user do
    json.extract! current_user, :login, :participated_games
  end

  games += Game.find current_user.participated_games
  games.uniq!
end

json.games games do |game|
  json.extract! game, 
    :id, 
    :time_mode,
    :chat_mode,
    :status,
    :powers_is_random,
    :is_public

  json.sides game.sides.count
  json.url game_path game
end

json.crsf form_authenticity_token
