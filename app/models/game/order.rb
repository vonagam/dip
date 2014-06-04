class Order
  include Mongoid::Document

  field :data, type: Hash

  embedded_in :game
  belongs_to :side

  validates :side_id, presence: true, uniqueness: true

  validate :game_in_progress, on: :create
  def game_in_progress
    if game.status != 'started'
      errors.add :state, 'Game not going'
    end
  end
  
  validate :parsable, on: :create
  def parsable
    state = game.state
    state.parse_orders state.get_gamestate, [self]
  #rescue
  #  errors.add :data, 'Not parsable'
  end

  validates :side, presence: true, on: :create
  def side
    game.sides.find side_id
  end
end
