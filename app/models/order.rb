class Order
  include Mongoid::Document

  field :data

  embedded_in :state
  belongs_to :side

  validates :state, :side_id, presence: true
  validates :side_id, uniqueness: true

  validate :game_in_progress, on: :create
  def game_in_progress
    if state.game.status != 'in_process'
      errors.add :state, 'Game not going'
    end
  end
  
  validate :valid, on: :create
  def valid
    state.parse_orders state.get_gamestate, [self]
  #rescue
  #  errors.add :data, 'Not parsable'
  end

  validates :side, presence: true, on: :create
  def side
    state.game.sides.find side_id
  end
end
