class SidesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @available_powers = Game.find( params[:game_id] ).available_powers
  end
  
  def create
    params[:side][:game] = Game.find params[:game_id]
    current_user.sides.create side_params
  end

  private

  def side_params 
    params.require(:side).permit!
  end
end
