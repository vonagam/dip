class OrdersController < ApplicationController
  before_action :authenticate_user!
  load_resource :game
  authorize_resource through: :game
  
  def create
    @state = @game.state
    @side = @game.side_of current_user

    create_params = order_params
    create_params[:data] = JSON.parse create_params[:data]

    if order = @game.order_of( @side )
      order.update_attributes! data: create_params[:data]
    else
      order = @game.orders.create create_params.merge side: @side
    end

    if order.errors.not_empty?
      respond_with order
    else
      render 'games/show'
    end
  end

  private

  def order_params 
    params.require(:order).permit :data
  end
end
