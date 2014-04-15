class GamesController < ApplicationController
  before_filter :authenticate_user!, only: [ :new, :create ]

  def index
  end

  def new
  end

  def create
    new_game = current_user.created_games.create game_params

    respond_with new_game, location: game_path(new_game)
  end

  def show
    @game = Game.find params[:id]
    @state = @game.states.last
  end

  def destroy
    Game.find( params[:id] ).destroy!
 
    redirect_to action: :index, status: 303
  end

  def start
    game = Game.find params[:id]

    return unless current_user == game.creator

    game.progress!
    
    respond_with game, location: game_path(game)
  end

  private

  def game_params 
    params.require(:game).permit!
  end
end
