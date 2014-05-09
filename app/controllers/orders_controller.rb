class OrdersController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    game = Game.find params[:game_id]

    side = game.user_side current_user

    state = game.states.last

    order = side.orders.build order_params.merge( state_id: state.id )

    order.save

    respond_with order, location: game_path(game)
  end

  def update
  end

  private

  def order_params 
    params.require(:order).permit!
  end
end
