class OrdersController < ApplicationController
  before_filter :authenticate_user!
  
  def create
  end

  def update
  end

  private

  def order_params 
    params.require(:order).permit!
  end
end
