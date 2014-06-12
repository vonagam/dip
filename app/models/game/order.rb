class Order
  include Mongoid::Document

  field :data, type: Hash

  embedded_in :game
  belongs_to :side

  attr_readonly :user_id

  validates :side_id, presence: true, uniqueness: true, on: :create
  validate :game_in_progress, :parsable

  def side
    game.sides.find side_id
  end

  protected

  def parsable
    state = game.state
    state.parse_orders [self]
  rescue
    errors.add :data, 'Not parsable'
  end

  def game_in_progress
    if game.status != 'started'
      errors.add :state, 'game not going'
    end
  end
end
