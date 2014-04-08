class State < ActiveRecord::Base
  # :data, :date, :type, :game_id

  belongs_to :game

  has_many :orders, dependent: :destroy
 
  def next_date!
    self.date += 0.5
  end

  def is_fall?
    date % 1 != 0
  end

  def create_next_state( next_data )
    state_parser = Diplomacy::Parser::State.new next_data
    game.states.build data: state_parser.to_json, date: date
  end

  def process
    state_parser = Diplomacy::Parser::State.new
    current_data = state_parser.from_json data
    order_parser = Diplomacy::Parser::Order.new current_data

    _process current_data, order_parser
  end

  def someone_win?( parsed_data )
    supply_centers = MAP_READER.maps['Standard'].supply_centers
    side_centers = {}
    supply_centers.each do |abbrv, area|
      owner = parsed_data[abbrv].owner
      next if owner.nil?
      side_centers[owner] ||= 0
      side_centers[owner] += 1
    end
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
      order = game.sides.where( name: power.to_s ).first.orders.where( state_id: id ).first
      order.update_attributes data: resolved.to_json
    end
  end
end

class State::Move < State
  def _process( current_data, order_parser )
    next_data, adjudicated_orders = ADJUDICATOR.resolve!( 
      current_data, 
      order_parser.parse_orders(orders.all), 
      is_fall?
    )

    update_orders adjudicated_orders

    next_state = create_next_state next_data

    return next_state.save if someone_win?( next_data )

    if next_data.dislodges.not_empty?
      next_state.type = 'State::Retreat'
    elsif is_fall?
      next_state.type = 'State::Supply'
    else
      next_state.type = 'State::Move'
      next_state.next_date!
    end

    next_state.save
  end
end

class State::Retreat < State
  def _process( current_data, order_parser )
    next_data, adjudicated_orders = ADJUDICATOR.resolve_retreats!( 
      current_data, 
      order_parser.parse_retreats(orders.all), 
      is_fall?
    )

    update_orders adjudicated_orders

    next_state = create_next_state next_data

    return next_state.save if someone_win?( next_data )

    if is_fall?
      next_state.type = 'State::Supply'
    else
      next_state.type = 'State::Move'
      next_state.next_date!
    end

    next_state.save
  end
end

class State::Supply < State
  def _process( current_data, order_parser )
    next_data, adjudicated_orders = ADJUDICATOR.resolve_builds!( 
      current_data, 
      order_parser.parse_builds(orders.all)
    )

    update_orders adjudicated_orders

    next_state = create_next_state next_data

    return next_state.save if someone_win?( next_data )

    next_state.type = 'State::Move'
    next_state.next_date!

    next_state.save
  end
end
