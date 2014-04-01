class State < ActiveRecord::Base
  #attr_accessible :data, :date, :type, :game_id

  belongs_to :game

  has_many :orders, dependent: :destroy
 
  def next_date
    self.date += 0.5
  end

  def is_fall?
    date % 1 != 0
  end

  def create_next_state( next_data )
    state_parser = Diplomacy::StateParser.new next_data
    game.states.build data: state_parser.dump_state, date: date
  end

  def process
    state_parser = Diplomacy::StateParser.new
    current_data = state_parser.parse_state state.data
    order_parser = Diplomacy::OrderParser.new current_data

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
end

class State::Move < State
  def _process( current_data, order_parser )
    next_data, adjudicated_orders = ADJUDICATOR.resolve!( 
      current_data, 
      order_parser.parse_orders(orders), 
      is_fall?
    )

    next_state = create_next_state next_data

    return next_state.save if someone_win?( next_data )

    if next_data.retreats.not_empty?
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
      order_parser.parse_retreats(orders), 
      is_fall?
    )

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
      order_parser.parse_builds(orders)
    )

    next_state = create_next_state next_data

    return next_state.save if someone_win?( next_data )

    next_state.type = 'State::Move'
    next_state.next_date!

    next_state.save
  end
end
