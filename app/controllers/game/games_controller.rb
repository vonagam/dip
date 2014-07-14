class GamesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show, :progress ]
  load_resource except: [ :create, :index ]
  load_and_authorize_resource only: [ :destroy, :start ]

  def index
    query = [{ is_public: true }]

    query.push({ :_id.in => current_user.participated_games }) if user_signed_in?
    
    @games = Game.or(*query) #.filter_by params[:query]
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
    redirect_to root_path, status: 303
  end

  def progress
    valid_request = 
    if @game.waiting? || @game.time_mode == 'manual'
      @game.creator == current_user
    else
      @game.secret == params[:secret]
    end

    @game.progress if valid_request
    
    head :ok
  end

  def rollback
    @game.rollback
    show
    render 'games/show'
  end

  private

  def game_params 
    params.require(:game).permit :name, :map, :is_public, :powers_is_random, :time_mode, :chat_mode
  end
end
