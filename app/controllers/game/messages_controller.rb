class MessagesController < ApplicationController
  before_filter :auth_user!, only: [:create]
  
  def create
    game = Game.find params[:game_id]
    state = game.state
    side = game.side_of current_user

    create_params = 
    message_params.merge({ 
      from: side.power,
      public: state.is_fall?
    })

    create_params[:to] = JSON.parse create_params[:to]

    message = game.messages.create create_params

    respond_with message, location: game_path(game)
  end

  def index
    game = Game.find params[:game_id]

    m = @game.messages.or public: true

    if user_signed_in? && side = game.side_of( current_user )
      m = m.or { to: side.power }, { from: side.power }
    end

    m = m.desc(:created_at).limit(50).offset( params[:offset].to_i )

    respond_with m
  end

  private

  def message_params 
    params.require(:message).permit :to, :text
  end
end
