class OrdersController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    game = Game.find params[:game_id]
    side = game.side_of current_user
    order = game.state.orders.build order_params.merge( side: side )
    order.save
    respond_with order, location: game_path(game)
  end

  def update
    game = Game.find params[:game_id]
    side = game.side_of current_user
    order = game.state.order_of side
    order.update_attributes! order_params
    respond_with order, location: game_path(game)
  end

  private

  def order_params 
    params.require(:order).permit!
  end
end
