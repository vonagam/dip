class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  load_resource :game
  load_and_authorize_resource through: :game, only: [:create]
  
  def create
    state = @game.state

    from = @game.status == 'waiting' ? current_user.login : @game.side_of(current_user).power

    is_public = @game.status != 'started' || state.is_fall?

    create_params = message_params.merge from: from, public: is_public

    create_params.delete :to if is_public

    message = @game.messages.build create_params

    message.save

    respond_with message, location: game_path(@game)
  end

  def index
    m = @game.messages.or({ public: true })

    if user_signed_in? && side = @game.side_of( current_user )
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
