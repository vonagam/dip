class OrdersController < ApplicationController
  before_action :authenticate_user!
  load_resource :game
  before_action :load_side_order
  authorize_resource

  def create
    @order.update_attributes order_params

    respond_with @order, location: game_path(@game)
  end

  private

  def load_side_order
    @side = @game.side_of current_user

    redirect_to root_path, status: 401 unless @side

    @order = @game.order_of( @side ) || @game.orders.build( side: @side )
  end

  def order_params 
    p = params.require(:order).permit :data
    p[:data] = JSON.parse p[:data]
    p
  end
end
