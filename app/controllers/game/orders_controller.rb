class OrdersController < ApplicationController
  before_filter :auth_user!
  
  def create
    game = Game.find params[:game_id]
    state = game.state
    side = game.side_of current_user

    if order = state.order_of( side )
      order.destroy
    end

    create_params = order_params.merge side: side
    create_params[:data] = JSON.parse create_params[:data]

    order = state.orders.create create_params

    respond_with order, location: game_path(game)
  end

  private

  def order_params 
    params.require(:order).permit :data
  end
end
