class GamesController < ApplicationController
  before_filter :auth_user!, only: [ :create ]

  def index
  end

  def create
    new_game = current_user.created_games.create game_params

    respond_with new_game, location: game_path(new_game)
  end

  def show
    @game = Game.find params[:id]
    @state = @game.state
    @side = @game.side_of current_user 
  end

  def destroy
    Game.find( params[:id] ).destroy!
 
    redirect_to action: :index, status: 303
  end

  def progress
    game = Game.find params[:id]

    case game.status
    when 'waiting'
      game.progress! if current_user == game.creator
    when 'in_process'
      game.progress!
    end
    
    redirect_to action: :show, status: 303
  end

  private

  def game_params 
    params.require(:game).permit!
  end
end
