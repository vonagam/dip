games = Game.where( is_public: true ).to_a

if user_signed_in?
  games += Game.find current_user.participated_games
  games.uniq!
end

json.games games do |game|
  json.extract! game, 
    :_id,
    :name,
    :time_mode,
    :chat_mode,
    :status,
    :powers_is_random,
    :is_public,
    :created_at,
    :slug

  json.states game.states.count
  json.sides game.sides.count
  json.creator game.creator.login
end
