class GamesController < ApplicationController
  before_filter :authenticate_user!, only: [ :new, :create ]

  def index
  end

  def new
  end

  def create
    new_game = current_user.created_games.create game_params

    render json: { success: true, redirect: game_path(new_game) }
  end

  def show
    @game = Game.find params[:id]

    side = @game.sides.first
    state = @game.states.last

    order_data = {
      ukr: {
        type: 'move',
        to: 'mos'
      }
    }.to_json

    #puts state.id

    #puts state.orders.count

    #side.orders.create state_id: state.id, data: order_data

    @game.progress!
  end

  private

  def game_params 
    params.require(:game).permit!
  end
end
