class WebsocketsController < WebsocketRails::BaseController
  def authorize_side
    game_id, side_name = message[:channel].split '_'

    game = Game.find game_id
    side = game.sides.find_by name: side_name

    if side.user == current_user
      accept_channel current_user
    else
      deny_channel message: 'authorization failed!'
    end
  end
end
