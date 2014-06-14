class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  load_resource :game
  load_and_authorize_resource through: :game, only: [:create]
  
  def create
    p = message_params

    p[:from] = @game.status == 'waiting' ? current_user.login : @game.side_of(current_user).power

    p[:is_public] = @game.status != 'started' || @game.chat_is_public?

    message = @game.messages.create p

    respond_with message, location: game_path(@game)
  end

  def index
    @side = @game.side_of current_user
    @offset = params[:offset]
  end

  private

  def message_params 
    params.require(:message).permit :to, :text
  end
end
