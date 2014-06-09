class GamesController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :destroy, :start ]
  load_resource except: [ :index, :new, :create ]
  load_and_authorize_resource only: [ :destroy, :start ]

  def index
  end

  def new
  end

  def create
    new_game = Game.create game_params.merge( creator: current_user )
    respond_with new_game
  end

  def show
    @state = @game.state
    @side = @game.side_of current_user
  end

  def destroy
    @game.destroy!
    redirect_to action: :index, status: 303
  end

  def start
    @game.progress!
    redirect_to action: :show, status: 303
  end

  def progress
    valid_request = 
    if @game.time_mode == 'manual'
      @game.creator == current_user
    else
      @game.secret == params[:secret]
    end

    @game.progress! if valid_request
    
    head :ok
  end

  private

  def game_params 
    params.require(:game).permit :name, :map, :is_public, :powers_is_random, :time_mode
  end
end
