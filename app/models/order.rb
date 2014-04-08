class Order < ActiveRecord::Base
  # :data

  belongs_to :side
  belongs_to :state

  validates :state, :side, presence: true
  validates :state_id, uniqueness: { scope: :side_id }

  validate :game_in_progress
  def game_in_progress
    if game.status != 'waiting'
      errors.add :state, 'Game already start'
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
