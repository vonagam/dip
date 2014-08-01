class GamesController < ApplicationController
  before_filter :authenticate_user!, except: [ :index, :show, :progress ]
  load_resource except: [ :create, :index ]
  authorize_resource only: [ :destroy, :start ]
  before_filter :authorize_progress, only: :progress

  def index
    query = [{is_public: true}]
    query.push(:_id.in => current_user.participated_games) if user_signed_in?
    @games = searching(Game.or(*query), params[:filters]).page
  end

  def create
    new_game = Game.create game_params.merge creator: current_user
    respond_with new_game
  end

  def show
  end

  def destroy
    @game.destroy!
    redirect_to root_path, status: 303
  end

  def start
    simple_action
  end

  def progress
    simple_action
  end

  def rollback
    simple_action
  end

  private

  def simple_action
    @game.send action_name
    head :ok
    send_websocket
    create_message
  end

  def authorize_progress
    valid_request = 
      if @game.time_mode == 'manual'
        @game.creator == current_user
      else
        @game.secret == params[:secret]
      end

    head :unauthorized unless valid_request
  end

  def send_websocket
    WebsocketRails[@game.id.to_s].trigger 'game', render_to_string(:changes)
  end

  def create_message
    return if @game.sandbox?
    text = @game.ended? ? 'END' : action_name.upcase
    @message = @game.messages.create from: 'Dip', is_public: true, text: text
    WebsocketRails[@game.id.to_s].trigger 'message', render_to_string(:show)
  end

  def game_params 
    params.require(:game).permit :name, :map, :is_public, :powers_is_random, :time_mode, :chat_mode
  end
end
