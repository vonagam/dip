class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  load_resource :game
  load_and_authorize_resource through: :game, only: [:create]
  
  def create
    p = message_params
    p[:from] = @game.waiting? ? current_user.login : @game.side_of(current_user).name
    p[:is_public] = @game.not_going? || @game.chat_is_public?
    @message = @game.messages.create p
    head :created, location: game_path(@game)
  end

  def index
    @side = @game.side_of current_user
    @offset = params[:offset]
  end

  private

  def send_websocket
    return if @message.errors.not_blank?

    game_id = @game.id.to_s

    channels =
      if @message.is_public
        [game_id]
      else
        [@message.from, @message.to].map{ |side| "#{game_id}_#{side}" }
      end

    message = render_to_string 'messages/show'

    channels.each do |channel|
      WebsocketRails[channel].trigger 'message', message
    end
  end

  def message_params 
    params.require(:message).permit :to, :text
  end
end
