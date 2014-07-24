participated = current_user.try(:participated_games) || []

json.partial! 'games/game', game: @game, participated: participated
json.chat_is_public @game.chat_is_public?
json.extract! @game, :taken_powers, :available_powers

json.partial! 'sides/index'
json.partial! 'states/index'
json.partial! 'messages/index'

json.partial! 'layouts/access'
