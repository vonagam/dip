class Side
  include Mongoid::Document

  field :power
  field :alive, type: Boolean, default: true
  field :orderable, type: Boolean, default: true

  embedded_in :game
  belongs_to :user
  
  validates :game, :user, presence: true
  validates :power, inclusion: {in: proc{|s| s.game.powers}}, allow_blank: true
  validates :user, uniqueness: true, on: :create
  validate :game_is_waiting, on: :create

  after_create :send_websocket

  def order
    order_in game
  end

  def order_in( game )
    game.order_of self
  end

  protected

  def send_websocket
    WebsocketRails[game.id.to_s].trigger 'side'
  end
  
  def game_is_waiting
    if game.status != 'waiting'
      errors.add :game, 'Game already start'
    end
  end
end
