class Side
  include Mongoid::Document

  field :power
  field :alive, type: Boolean, default: true
  field :orderable, type: Boolean, default: true

  embedded_in :game
  belongs_to :user
  
  validates :game, :user, presence: true
  validates :power, inclusion: {in: proc{|s| s.game.powers}}, allow_blank: true, on: :create
  validates :user, uniqueness: true, on: :create
  validate :game_is_waiting, on: :create

  after_create :add_participated_game, :send_websocket
  after_destroy :remove_participated_game, :send_websocket

  def order
    game.order_of self
  end

  protected

  def add_participated_game
    user.push participated_games: id
  end
  def remove_participated_game
    user.pull participated_games: id
  end

  def send_websocket
    WebsocketRails[game.id.to_s].trigger 'side', game.taken_powers
  end
  
  def game_is_waiting
    if game.status != 'waiting'
      errors.add :game, 'Game already start'
    end
  end
end
