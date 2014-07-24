participated = current_user.try(:participated_games) || []

json.games @games, partial: 'games/game', as: :game, participated: participated

json.page @games.current_page
json.pages @games.total_pages

json.maps Map.all do |map|
  json.extract! map, :id, :name
end

json.partial! 'layouts/access'
