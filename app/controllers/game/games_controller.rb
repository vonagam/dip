class GamesController < ApplicationController
  before_filter :auth_user!, only: [ :create, :destroy, :start ]
  before_filter :find_game, except: [ :index, :new, :create ]

  def index
  end

  def show
    @state = @game.state
    @side = @game.side_of current_user
  end

  def new
  end

  def create
    new_game = current_user.created_games.create game_params

    respond_with new_game, location: game_path(new_game)
  end

  def destroy
    if @game.creator == current_user || current_user.login == 'vonagam'
      @game.destroy!
    end
 
    redirect_to action: :index, status: 303
  end

  def start
    if @game.status == 'waiting' && @game.creator == current_user
      @game.progress!
    end
    
    redirect_to action: :show, status: 303
  end

  def progress
    valid_request = 
    case @game
      when Game::Manual then @game.creator == current_user
      when Game::Sheduled then @game.secret == params[:secret]
    end

    @game.progress if valid_request
    head :ok
  end

  private

  def game_params 
    params.require(:game).permit!
  end
end
