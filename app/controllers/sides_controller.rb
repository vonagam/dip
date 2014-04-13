class SidesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @game = Game.find params[:game_id]
  end
  
  def create
    game = Game.find params[:game_id]
    params[:side][:game] = game
    side = current_user.sides.create side_params
    respond_with side, location: game_path(game)
  end

  private

  def side_params 
    params.require(:side).permit!
  end
end
