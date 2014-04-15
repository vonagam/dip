class Side < ActiveRecord::Base
  # :name

  belongs_to :game

  belongs_to :user

  has_many :orders, dependent: :destroy


  validates :game, presence: true
  
  validates :user, presence: true, uniqueness: { scope: :game_id }

  validate :game_is_waiting
  def game_is_waiting
    if game.not_waiting?
      errors.add :game_id, 'Game already start'
    end
  end

  validate :power_name
  def power_name
    if name != 'Random' && game.available_powers.not_include?( name )
      errors.add :name, 'Power not found'
    end
  end
end
