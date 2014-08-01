json.games @games do |game|
  json.partial! partial: 'games/game', game: game
  json.states_count game.states.count
  json.sides_count game.sides.count
end

json.page @games.current_page
json.pages @games.total_pages

json.maps Map.all do |map|
  json.extract! map, :id, :name
end

json.partial! 'layouts/access'
