class SidesController < ApplicationController
  before_action :authenticate_user!
  load_resource :game
   
  def create
    params = side_params.merge user: current_user
    params.delete :power if @game.powers_is_random
    side = @game.sides.create params
    respond_with @game, location: game_path(@game)
  end

  def destroy
    @game.side_of( current_user ).destroy unless current_user == game.creator
    respond_with nil, location: game_path(@game)
  end

  private

  def side_params 
    params.require(:side).permit :power
  end
end
