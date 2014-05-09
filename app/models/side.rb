class Side
  include Mongoid::Document


  embedded_in :game

  belongs_to :user
  belongs_to :power

  has_many :orders
  

  validates :user, presence: true, uniqueness: true
  validate :game_is_waiting
  validate :power_valid


  def order
    game.state.orders.find_by side_id: id
  end


  protected
  
  def game_is_waiting
    if game.status != 'waiting'
      errors.add :game_id, 'Game already start'
    end
  end

  def power_valid
    if power_id && game.map.powers.all.pluck(:id).not_include?( power_id )
      errors.add :power, 'Power not found'
    end
  end
end
