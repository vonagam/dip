class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :is_public, type: Boolean
  field :to
  field :from
  field :text

  embedded_in :game

  validates :text, :from, presence: true, on: :create
  validate :to_valid_powers, on: :create

  before_validation :check_status_if_choosable, :delete_to_if_public, on: :create
  after_create :send_websocket

  protected

  def delete_to_if_public
    self.to = nil if is_public
    true
  end

  def check_status_if_choosable
    if is_public.nil? && game.chat_is_public?.nil?
      self.is_public = to == 'Public'
    end
    true
  end

  def send_websocket
    game_id = game.id.to_s

    channels =
    if is_public
      [game_id]
    else
      [from,to].map{ |side| "#{game_id}_#{side}" }
    end

    channels.each do |channel|
      WebsocketRails[channel].trigger 'message', self
    end
  end

  def to_valid_powers
    return if is_public

    error = 
    if to.blank?
      :no_one
    elsif to == from
      :yourself
    elsif game.alive_sides.map(&:name).not_include?(to)
      :not_alive
    end

    errors.add :to, error if error
  end
end
