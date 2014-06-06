class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :public, type: Boolean
  field :to
  field :from
  field :text

  embedded_in :game

  validates :text, :from, presence: true, on: :create
  validate :to_valid_powers, on: :create

  after_create :send_websocket

  protected

  def send_websocket
    game_id = game.id.to_s

    channels =
    if public
      [game_id]
    else
      [from,to].map{ |side| "#{game_id}_#{side}" }
    end

    channels.each do |channel|
      WebsocketRails[channel].trigger 'message', self
    end
  end

  def to_valid_powers
    return if public

    error = 
    if to.blank?
      'message to no one'
    elsif to == from
      'message to yourself'
    elsif game.alive_powers.not_include?(to)
      'not alive power'
    end

    errors.add :to, error if error
  end
end
