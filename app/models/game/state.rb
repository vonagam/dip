class State
  include Mongoid::Document

  field :data
  field :date, type: Integer

  embedded_in :game
  embeds_many :orders

  delegate :map, to: :game
  delegate :info, :adjudicator, to: :map, prefix: true

  def order_of( side )
    orders.find_by side_id: side.id
  end
 
  def next_date!
    self.date += 1
  end

  def is_fall?
    date % 2 == 1
  end

  def type
    _type.demodulize
  end

  def parse_orders( gamestate, what = nil )
    what ||= orders.all
    Engine::Parser::Order.new( gamestate ).parse_orders what, type
  end

  def get_gamestate
    Engine::Parser::State.new.from_json data
  end

  def create_next_state( next_data )
    state_parser = Engine::Parser::State.new next_data
    game.states.build data: state_parser.to_json, date: date
  end

  def process
    gamestate = get_gamestate

    next_data, adjudicated_orders = resolve gamestate

    update_orders adjudicated_orders

    next_state = create_next_state next_data

    return next_state.save if someone_win?( next_data )

    next_state._type = 'State::'+next_state_type( next_state, next_data )

    next_state.next_date! if next_state._type == 'State::Move'

    next_state.save
  end

  def someone_win?( parsed_data )
    supply_centers = map_info.supply_centers
    side_centers = {}
    supply_centers.each do |abbrv, area|
      owner = parsed_data[abbrv].owner
      next if owner.nil?
      side_centers[owner] ||= 0
      side_centers[owner] += 1
    end
    puts side_centers.values.max
    puts supply_centers.length / 2
    side_centers.values.max > supply_centers.length / 2
  end

  def update_orders( resolved_orders )
    powers = {}

    resolved_orders.each do |order|
      order_data = order.origin
      power = order_data.delete :power
      region = order_data.delete :region
      order_data['result'] = order.resolution_readable

      ( powers[power] ||= {} )[region] = order_data
    end

    powers.each do |power, resolved|
      order = game.sides.find_by( power: power.to_s ).order
      order.update_attributes data: resolved.to_json
    end
  end
end

class State::Move < State
  def resolve( gamestate )
    map_adjudicator.resolve!( gamestate, parse_orders( gamestate ), is_fall? )
  end
  def next_state_type( next_state, next_data )
    if next_data.dislodges.not_empty?
      'Retreat'
    else
      is_fall? ? 'Supply' : 'Move'
    end
  end
end

class State::Retreat < State
  def resolve( gamestate )
    map_adjudicator.resolve_retreats!( gamestate, parse_orders( gamestate ), is_fall? )
  end
  def next_state_type( next_state, next_data )
    is_fall? ? 'Supply' : 'Move'
  end
end

class State::Supply < State
  def resolve( gamestate )
    map_adjudicator.resolve_builds!( gamestate, parse_orders( gamestate ) )
  end
  def next_state_type( next_state, next_data )
    'Move'
  end
end
