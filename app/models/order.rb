class Order
  include Mongoid::Document

  field :data

  embedded_in :state
  belongs_to :side

  validates :state, :side, presence: true, on: :create
  validates :side, uniqueness: true

  validate :game_in_progress, on: :create
  def game_in_progress
    if state.game.status != 'in_process'
      errors.add :state, 'Game not going'
    end
  end
  
  validate :valid
  def valid
    state_parser = Diplomacy::Parser::State.new
    parsed_state = state_parser.from_json state.data
    order_parser = Diplomacy::Parser::Order.new parsed_state
    order_parser.parse_orders [self]
  #rescue
  #  errors.add :data, 'Not parsable'
  end

  def side
    state.game.sides.find side_id
  end
end
