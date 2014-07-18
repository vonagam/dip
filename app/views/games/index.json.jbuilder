json.games @games do |game|
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

if user_signed_in?
  json.participated current_user.participated_games
end

json.page @games.current_page
json.pages @games.total_pages
