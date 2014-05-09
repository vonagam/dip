class Side
  include Mongoid::Document

  field :power

  belongs_to :game
  belongs_to :user
  has_many :orders
  
  validates :game, :user, presence: true
  validates :user, uniqueness: { scope: :game }
  
  validate :game_is_waiting
  validate :power_valid

  def order
    game.state.orders.find_by side: self
  end

  protected
  
  def game_is_waiting
    if game.status != 'waiting'
      errors.add :game_id, 'Game already start'
    end
  end

  def power_valid
    if power.not_blank? && game.powers.not_include?( power )
      errors.add :power, 'Power not found'
    end
  end
end
