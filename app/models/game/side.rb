class Side
  include Mongoid::Document
  include Mongoid::Enum

  field :power, type: Array
  enum :status, [:fighting, :draw, :surrendered, :lost, :won]
  field :orderable, type: Boolean, default: true
  field :name

  embedded_in :game
  belongs_to :user

  attr_readonly :user_id
  
  before_validation :delete_power_if_powers_random
  
  validates :user_id, presence: true, uniqueness: true, on: :create
  validate :powers_on_map
  validate :game_has_space, on: :create

  after_create :add_participated_game, :websockets
  after_update :websockets
  after_destroy :remove_participated_game, :websockets

  def order
    game.order_of self
  end

  def return_unallowed_powers( powers )
    powers.reject{ |x| power.include? x }
  end

  def save_name
    name =
    case power.size
    when 0, game.powers.size then user.login
    when 1 then power.first
    else power.reduce(''){ |sum,p| sum + p[0] }
    end

    update_attribute :name, name
  end

  protected

  def powers_on_map
    return if power.blank?

    if power.any? { |p| game.powers.not_include? p }
      errors.add :power, :unknown
    end
  end

  def game_has_space
    if game.powers.size == game.sides.count
      errors.add :game, :filled
    end
  end

  def delete_power_if_powers_random
    self.power = nil if game.waiting? && game.powers_is_random
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
