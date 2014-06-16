require 'rails_helper'

describe MessagesController do
  before do
    @game = create :game, chat_mode: 'both'
    @user = @game.creator
    @side = @user.side_in @game
    sign_in @user
  end

  def send_message_create( message )
    post :create, format: :json, game_id: @game.id, message: message
  end

  it 'one private message' do
    second_side = create :side, game: @game

    progress!

    from = @side.reload.name
    to = second_side.reload.name

    expect{ send_message_create to: to, text: 'asd' }
    .to change{ @game.reload.messages.count }.from(1).to(2)
  end
end
