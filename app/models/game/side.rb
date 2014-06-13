class Side
  include Mongoid::Document

  field :power
  field :alive, type: Boolean, default: true
  field :orderable, type: Boolean, default: true

  embedded_in :game
  belongs_to :user

  attr_readonly :user_id
  
  before_validation :delete_power_if_powers_random
  
  validates :user_id, presence: true, uniqueness: true, on: :create
  validates :power, inclusion: {in: proc{|s| s.game.powers}}, allow_blank: true
  validate :game_has_space, on: :create

  after_create :add_participated_game, :websockets
  after_update :websockets
  after_destroy :remove_participated_game, :websockets

  def order
    game.order_of self
  end

  protected

  def game_has_space
    if game.powers.size == game.sides.count
      errors.add :game, :filled
    end
  end

  def delete_power_if_powers_random
    self.power = nil if game.status == 'waiting' && game.powers_is_random
  end

  def add_participated_game
    user.push participated_games: game.id
  end
  def remove_participated_game
    user.pull participated_games: game.id
  end

  def websockets
    WebsocketRails["#{game.id}_#{power}"].make_private if power
    WebsocketRails[game.id.to_s].trigger 'side', self
  end
end
