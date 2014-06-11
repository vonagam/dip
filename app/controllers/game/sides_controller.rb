class SidesController < ApplicationController
  before_action :authenticate_user!
  load_resource :game
   
  def create
    if side = @game.side_of( current_user )
      side.update_attributes side_params unless @game.creator == current_user
    else
      side = @game.sides.create side_params.merge user: current_user
    end

    if side.errors.not_empty?
      respond_with side
    else
      respond_with nil, location: game_path(@game)
    end
  end

  def destroy
    @game.side_of( current_user ).destroy unless @game.creator == current_user 
    head :ok
  end

  private

  def side_params 
    params.require(:side).permit :power
  end
end
