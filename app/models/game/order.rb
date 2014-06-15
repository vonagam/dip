class Order
  include Mongoid::Document

  field :data, type: Hash

  embedded_in :game
  belongs_to :side

  attr_readonly :user_id

  validates :side_id, presence: true, uniqueness: true, on: :create
  validate :game_in_progress, :parsable
  before_validation :remove_unallowed_powers

  def side
    game.sides.find side_id
  end

  protected

  def remove_unallowed_powers
    return unless data && data.is_a?(Hash)

    powers = data.keys

    self.data = self.data.except!( *side.return_unallowed_powers( powers ) )

    true
  end

  def parsable
    state = game.state
    state.parse_orders data
  rescue
    errors.add :data, :not_parsable
  end

  def game_in_progress
    unless game.going?
      errors.add :game, :not_going
    end
  end
end
