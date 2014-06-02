class OrdersController < ApplicationController
  before_filter :auth_user!
  
  def create
    @game = Game.find params[:game_id]
    @state = @game.state
    @side = @game.side_of current_user

    create_params = order_params
    create_params[:data] = JSON.parse create_params[:data]

    if order = @game.order_of( @side )
      order.update_attributes! data: create_params[:data]
    else
      @game.orders.create create_params.merge side: @side
    end

    render 'games/show'
  end

  private

  def order_params 
    params.require(:order).permit :data
  end
end
