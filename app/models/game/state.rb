class State
  include Mongoid::Document

  attr_accessor :gamestate

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

  def parse_orders( what = nil )
    what ||= game.orders.all
    @gamestate ||= get_gamestate
    
    Engine::Parser::Order.new( @gamestate ).parse_orders what, type
  end

  def get_gamestate
    @gamestate = Engine::Parser::State.new.to_state data
  end

  def create_next_state( areas_states )
    state_parser = Engine::Parser::State.new areas_states
    game.states.build data: state_parser.to_hash, date: date
  end

  def process
    areas_states, adjudicated_orders = map_adjudicator.send( 
      self.class.resolve, 
      get_gamestate, 
      parse_orders, 
      is_fall?
    )

    update_orders adjudicated_orders

    next_state = create_next_state areas_states

    return next_state.save if someone_win?( areas_states )

    sc = self.class
    while nc = sc.next_state_class( is_fall? ) 
      break unless nc.allow_orders( map_info, areas_states ).empty?
      sc = nc
    end

    next_state._type = nc.name

    next_state.next_date! if nc == State::Move

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
    orderable = self.class.allow_orders map_info, areas_states

    game.sides.each do |side|
      side.update_attributes! orderable: orderable.include?(side.power.to_sym)
    end
  end
end

class State::Move < State
  def self.resolve
    :resolve!
  end
  def self.next_state_class( is_fall )
    State::Retreat
  end
  def self.allow_orders( map_info, areas_states )
    areas_states.map{ |abbr, area| area.unit.try :nationality }
  end
end

class State::Retreat < State
  def self.resolve
    :resolve_retreats!
  end
  def self.next_state_class( is_fall )
    is_fall ? State::Supply : State::Move
  end
  def self.allow_orders( map_info, areas_states )
    areas_states.dislodges.map{ |abbr, dislodge| dislodge.unit.nationality }
  end
end

class State::Supply < State
  def self.resolve
    :resolve_builds!
  end
  def self.next_state_class( is_fall )
    State::Move
  end
  def self.allow_orders( map_info, areas_states )
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

    powers.select{ |power, supply| supply != 0 }.keys
  end
end
