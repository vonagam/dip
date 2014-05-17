require 'spec_helper'

describe OrdersController do
  before do
    @user = create :user
    @map = Map.find_by name: 'Standart'
    @game = @user.created_games.create map: @map
    @user.side_in( @game ).update_attributes power: 'Italy'
    @game.progress!
  end

  it 'two orders' do
    sign_in @user

    post :create, game_id: @game.id, order: { data: '{"rom":{"type":"Move","to":"tus"}}' }

    @game.reload.progress!

    post :create, game_id: @game.id, order: { data: '{"tus":{"type":"Move","to":"pie"}}' }
    post :create, format: :json, game_id: @game.id, order: { data: '{"tus":{"type":"Move","to":"rom"}}' }

    puts response.body

    #@game.reload.progress!
  end
end
