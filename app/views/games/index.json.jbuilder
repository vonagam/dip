json.games @games, partial: 'games/game', as: :game

json.page @games.current_page
json.pages @games.total_pages

json.maps Map.all do |map|
  json.extract! map, :id, :name
end

json.partial! 'layouts/access'
