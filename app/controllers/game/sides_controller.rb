class SidesController < ApplicationController
  before_action :authenticate_user!
  load_resource :game
  before_action :find_side
  after_action :send_websocket, except: :index
  authorize_resource through: :game, except: :index

  def create
    @side.update_attributes side_params
    respond_with @side, location: game_path(@game)
  end

  def destroy
    @side.destroy
    head :ok
  end

  private

  def send_websocket
    if @side.errors.empty?
      WebsocketRails[@game.id.to_s].trigger 'side', render_to_string 'sides/index'
    end
  end

  def find_side
    @side = @game.side_of(current_user) || @game.sides.build(user: current_user)
  end

  def side_params
    p = params.require(:side).permit :power
    p[:power] = p[:power].blank? ? nil : [p[:power]] 
    p
  end
end
