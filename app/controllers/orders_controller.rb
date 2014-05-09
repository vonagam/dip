class OrdersController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    game = Game.find params[:game_id]

    side = game.user_side current_user

    order = side.orders.build order_params.merge( state: game.state )

    order.save

    respond_with order, location: game_path(game)
  end

  def update
    game = Game.find params[:game_id]

    side = game.user_side current_user

    order = side.order

    order.update_attributes order_params

    respond_with order, location: game_path(game)
  end

  private

  def order_params 
    params.require(:order).permit!
  end
end
