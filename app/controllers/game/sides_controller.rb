class SidesController < ApplicationController
  before_filter :auth_user!
  
  def new
    @game = Game.find params[:game_id]
  end
  
  def create
    game = Game.find params[:game_id]
    side = game.add_side( current_user, side_params[:power] )
    respond_with side, location: game_path(game)
  end

  def destroy
    game = Game.find params[:game_id]
    game.side_of( current_user ).destroy unless current_user != game.creator
    respond_with nil, location: game_path(game)
  end

  private

  def side_params 
    params.require(:side).permit!
  end
end
