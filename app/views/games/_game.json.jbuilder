json.extract! game, 
  :id,
  :name,
  :status,
  :ended_by,
  :time_mode,
  :chat_mode,
  :powers_is_random,
  :is_public,
  :created_at,
  :slug

json.creator game.creator.login
json.map_name game.map.name
