class Side
  include Mongoid::Document
  include Mongoid::Enum

  field :power, type: Array
  enum :status, [:fighting, :draw, :surrendered, :lost, :won]
  field :orderable, type: Boolean, default: true
  field :name

  embedded_in :game
  belongs_to :user
  
  before_validation :delete_power_if_powers_random
  
  validates :user_id, presence: true, uniqueness: true, on: :create
  validate :powers_on_map
  validate :game_has_space, on: :create

  after_create :add_participated_game
  after_destroy :remove_participated_game

  def order
    game.order_of self
  end

  def return_unallowed_powers( powers )
    powers.reject{ |x| power.include? x }
  end

  def save_name
    name =
      case power.size
      when 1 then power.first
      when game.powers.size then 'Host'
      else power.reduce(''){ |sum,p| sum + p[0] }
      end

    update_attribute :name, name
  end

  protected

  def powers_on_map
    if power.not_blank? && power.any?{ |p| game.available_powers.not_include? p }
      errors.add :power, :unknown
    end
  end

  def game_has_space
    if game.powers.size == game.sides.count
      errors.add :game, :filled
    end
  end

  def delete_power_if_powers_random
    if game.waiting? && game.powers_is_random
      self.power = nil
    end
  end

  def add_participated_game
    user.push participated_games: game.id
  end
  def remove_participated_game
    user.pull participated_games: game.id
  end
end
