class Order < ActiveRecord::Base
  #attr_accessible :data

  belongs_to :side
  belongs_to :state

  validate :valid

  def valid
    return errors.add( :data, 'Cannot be nil' ) if data.nil?

    state_parser = Diplomacy::StateParser.new
    parsed_state = state_parser.parse_state state.data
    order_parser = Diplomacy::OrderParser.new parsed_state
    order_parser.parse_orders [self]

  rescue Diplomacy::WrongOrderTypeError => e
    errors.add :data, e.message
  rescue Diplomacy::OrderParsingError => e
    errors.add :data, e.message
  end
end
