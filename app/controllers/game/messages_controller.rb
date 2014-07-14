class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  load_resource :game
  load_and_authorize_resource through: :game, only: [:create]
  
  def create
    p = message_params

    p[:from] = @game.waiting? ? current_user.login : @game.side_of(current_user).name

    p[:is_public] = @game.not_going? || @game.chat_is_public?

    message = @game.messages.create p

    respond_with message, location: game_path(@game)
  end

  def index
    side = @game.side_of current_user
    offset = params[:offset]

    @messages = @game.messages

    if @game.status != 'ended'
      select = [ { is_public: true } ]
      select.push({ to: @side.power }, { from: @side.power }) if @side
      @messages = @messages.or *select
    end

    @messages = @messages.where({ :created_at.lt => @offset }) if @offset
    
    @messages = @messages.desc(:created_at).limit(10).to_a
  end

  private

  def message_params 
    params.require(:message).permit :to, :text
  end
end
