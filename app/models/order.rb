class Order
  include Mongoid::Document


  field :data


  embedded_in :state

  belongs_to :side


  validates :side, presence: true, uniqueness: true

  validate :game_in_progress
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
  rescue
    errors.add :data, 'Not parsable'
  end
end
