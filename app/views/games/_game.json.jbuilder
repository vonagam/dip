json.extract! game, 
  :id,
  :name,
  :time_mode,
  :chat_mode,
  :status,
  :powers_is_random,
  :is_public,
  :created_at,
  :slug

json.states_count game.states.count
json.sides_count game.sides.count
json.creator game.creator.login

json.is_participated participated.include?(game.id)
