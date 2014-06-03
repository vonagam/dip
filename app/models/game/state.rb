class State
  include Mongoid::Document

  field :data, type: Hash
  field :date, type: Integer
  field :end_at, type: Time
  field :resulted_orders, type: Hash

  embedded_in :game

  delegate :map, to: :game
  delegate :info, :adjudicator, to: :map, prefix: true

  after_create :state_changing

  MINUTES = { 'Move' => 4, 'Retreat' => 2, 'Supply' => 3 }

  def state_changing
    return if game.status == 'waiting'

    WebsocketRails[game.id.to_s].trigger 'state'

    text = "#{date/2}.#{date%2}:#{type}"
    game.messages.create from: '=', public: true, text: text

    if type != 'State'
      #end_at = MINUTES[type].minutes.from_now
      end_at = 1.minutes.from_now
      update_attributes! end_at: end_at
      RestClient
      .delay( run_at: end_at )
      .get( "http://#{APP_HOST}/games/#{game.id}/progress" )
    end
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
    what ||= game.orders.all
    Engine::Parser::Order.new( gamestate ).parse_orders what, type
  end

  def get_gamestate
    Engine::Parser::State.new.to_state data
  end

  def create_next_state( areas_states )
    state_parser = Engine::Parser::State.new areas_states
    game.states.build data: state_parser.to_hash, date: date
  end

  def process
    areas_states, adjudicated_orders = resolve get_gamestate

    update_orders adjudicated_orders

    next_state = create_next_state areas_states

    return next_state.save if someone_win?( areas_states )

    next_state._type = 'State::'+next_state_type( areas_states )

    next_state.next_date! if next_state._type == 'State::Move'

    next_state.save

    game.reload.state.update_orderable areas_states
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
    side_centers.values.max > supply_centers.length / 2
  end

  def update_orders( resolved_orders )
    powers = {}

    resolved_orders.each do |resolver_order|
      raw = resolver_order.raw
      order = raw[:order]
      power = raw[:power]
      region = raw[:region]

      order['result'] = resolver_order.resolution_readable

      ( powers[power] ||= {} )[region] = order
    end

    update_attributes! resulted_orders: powers

    game.reload.orders.destroy_all
  end

  def update_orderable( areas_states )
    orderable = Set.new
    allow_orders orderable, areas_states

    game.sides.each do |side|
      side.update_attributes! orderable: orderable.include?(side.power.to_sym)
    end
  end
end

class State::Move < State
  def resolve( gamestate )
    map_adjudicator.resolve!( gamestate, parse_orders( gamestate ), is_fall? )
  end
  def next_state_type( areas_states )
    if areas_states.dislodges.not_empty?
      'Retreat'
    else
      is_fall? ? 'Supply' : 'Move'
    end
  end
  def allow_orders( orderable, areas_states )
    areas_states.each do |abbr, area|
      orderable.add( area.unit.nationality ) if area.unit
    end
  end
end

class State::Retreat < State
  def resolve( gamestate )
    map_adjudicator.resolve_retreats!( gamestate, parse_orders( gamestate ), is_fall? )
  end
  def next_state_type( areas_states )
    is_fall? ? 'Supply' : 'Move'
  end
  def allow_orders( orderable, areas_states )
    areas_states.dislodges.each do |abbr, dislodge|
      orderable.add( dislodge.unit.nationality ) if dislodge.unit
    end
  end
end

class State::Supply < State
  def resolve( gamestate )
    map_adjudicator.resolve_builds!( gamestate, parse_orders( gamestate ) )
  end
  def next_state_type( areas_states )
    'Move'
  end
  def allow_orders( orderable, areas_states )
    powers = {}

    supply_centers = map_info.supply_centers

    supply_centers.each do |abbrv, area|
      if owner = areas_states[abbrv].owner
        powers[owner] ||= 0
        powers[owner] += 1
      end
    end

    areas_states.each do |abbr, area|
      if unit = area.unit
        powers[unit.nationality] ||= 0
        powers[unit.nationality] -= 1
      end
    end

    orderable.merge powers.select{ |power, supply| supply != 0 }.keys
  end
end
