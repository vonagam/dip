require 'rails_helper'

describe OrdersController do
  before do
    @game = create :game
    @user = @game.creator
    @side = @user.side_in @game

    @side.update_attributes power: ['Italy']
    sign_in @user
  end

  def send_post_create( order_data )
    post :create, 
      format: :json, 
      game_id: @game.id, 
      order: { data: order_json( { 'Italy' => order_data } ) }
  end

  it 'two orders' do
    progress!

    expect{ send_post_create( rom: [:Move,:tus] ) }
    .to change{ @game.reload.orders.count }.from(0).to(1)

    expect{ send_post_create( rom: [:Move,:apu] ) }
    .not_to change{ @game.reload.orders.count }.from(1)
  end

  it 'not going' do
    ['waiting','finished'].each do |status|
      @game.update_attributes status: status

      expect{ send_post_create( rom: [:Move,:tus] ) }
      .to raise_error( CanCan::AccessDenied )
    end
  end

  it 'not signed' do
    progress!
    sign_out @user

    send_post_create rom: [:Move,:tus]

    expect( response.status ).to eq 401
  end

  it 'not participated' do
    progress!
    sign_out @user
    sign_in create :user

    send_post_create rom: [:Move,:tus]
    
    expect( response.status ).to eq 401
  end
end
