require 'rails_helper'

describe SidesController do
  before do
    @game = create :game
    @user = create :user
    sign_in @user
  end

  def send_side_create( power = [] )
    post :create, format: :json, game_id: @game.id, side: { power: power }
  end
  def send_side_destroy
    delete :destroy, format: :json, game_id: @game.id
  end

  it 'two sides' do
    expect{ send_side_create }
    .to change{ @game.reload.sides.count }.from(1).to(2)

    expect{ send_side_create( ['Austria'] ) }
    .not_to change{ @game.reload.sides.count }.from(2)
  end

  it 'not waiting' do
    [:going,:ended].each do |status|
      @game.update_attributes status: status

      expect{ send_side_create }
      .to raise_error( CanCan::AccessDenied )
    end
  end

  it 'not signed' do
    sign_out @user
    send_side_create
    expect( response.status ).to eq 401
  end
end
