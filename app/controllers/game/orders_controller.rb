class OrdersController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    game = Game.find params[:game_id]
    state = game.state
    side = game.side_of current_user

    if order = state.order_of( side )
      order.destroy
    end

    order = state.orders.create order_params.merge side: side

    respond_with order, location: game_path(game)
  end

  private

  def order_params 
    params.require(:order).permit :data
  end
end
