class WebsocketsController < WebsocketRails::BaseController
  def authorize_side
    channel = WebsocketRails[message[:channel]]

    info = message[:channel].split '_'

    game = Game.find info[0]
    side = game.sides.find_by power: info[1]

    if side.user == current_user
      accept_channel current_user
    else
      deny_channel message: 'authorization failed!'
    end
  end
end
