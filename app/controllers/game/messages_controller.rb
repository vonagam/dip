class MessagesController < ApplicationController
  before_filter :auth_user!, only: [:create]
  
  def create
    game = Game.find params[:game_id]
    state = game.state
    side = game.side_of current_user

    create_params = message_params.merge({
      from: side.power,
      public: state.is_fall?
    })

    create_params.delete(:to) if create_params[:public]

    message = game.messages.build create_params

    message.save

    respond_with message, location: nil #game_path(game)
  end

  def index
    game = Game.find params[:game_id]

    m = game.messages.or({ public: true })

    if user_signed_in? && side = game.side_of( current_user )
      m = m.or({ to: side.power }, { from: side.power })
    end

    if params[:offset]
      m = m.and( :created_at.lte => Date.parse(params[:offset]) )
    end

    m = m.desc(:created_at).limit(50).to_a

    respond_with m
  end

  private

  def message_params 
    params.require(:message).permit :to, :text
  end
end
