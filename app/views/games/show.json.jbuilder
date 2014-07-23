participated = current_user.try(:participated_games) || []

json.partial! 'games/game', game: @game, participated: participated
json.chat_is_public @game.chat_is_public?

render template: 'sides/index'
render template: 'states/index'
render template: 'messages/index'

json.partial! 'layouts/access'
