class SidesController < ApplicationController
  before_action :authenticate_user!
  load_resource :game
  before_action :find_side
  authorize_resource through: :game, except: :index

  def index
  end
   
  def create
    @side.update_attributes side_params

    respond_with @side, location: game_path(@game)
  end

  def destroy
    @side.destroy
    
    head :ok
  end

  private

  def find_side
    @side = @game.side_of(current_user) || @game.sides.build(user: current_user)
  end

  def side_params
    p = params.require(:side).permit :power
    p[:power] = p[:power].blank? ? nil : [p[:power]] 
    p
  end
end
