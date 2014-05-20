class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include WebsocketNotifier

  field :public, type: Boolean
  field :to
  field :from
  field :text

  embedded_in :game

  validates :text, :from, presence: true, on: :create
  #validate :to_valid_powers, on: :create

  triggers_websocket :message, &:get_channels

  def get_channels
    game_id = game.id.to_s

    if public
      [game_id]
    else
      [from,to].map{ |side| "#{game_id}_#{side}" }
    end
  end

  protected

  def to_valid_powers
    return if public

    error = 
    if to.blank?
      'message to no one'
    elsif to == from
      'message to yourself'
    elsif game.taken_powers.not_include?(to)
      'not existing power'
    end

    errors.add :to, error if error
  end
end
