class GamesController < ApplicationController
  def index
  end

  def create
    new_game = Game.create game_params

    render json: { success: true, redirect: game_path(new_game) }
  end

  def show
    @game = Game.find params[:id]
  end

  def order
  end

  private

  def game_params 
    params.require(:game).permit!
  end
end
