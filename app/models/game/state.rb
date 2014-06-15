class State
  include Mongoid::Document

  field :data, type: Hash
  field :date, type: Integer
  field :end_at, type: Time
  field :resulted_orders, type: Hash

  embedded_in :game

  delegate :map, to: :game
  delegate :count_units, :count_supplies, to: :class

  after_create :send_websocket

  def is_fall?
    date % 2 == 1
  end

  def type
    _type.demodulize
  end

  def parse_orders( what = nil )
    what ||= game.orders.all.map!{ |x| x.data }.reduce({}, :merge)
    
    Engine::Parser::Order.new( gamestate ).parse_orders what, type
  end

  def process
    @areas_states, adjudicated_orders = map.adjudicator.send( 
      self.class::RESOLVE_METHOD, 
      gamestate, 
      parse_orders, 
      is_fall?
    )

    update_orders adjudicated_orders

    next_state = create_next_state

    return next_state.save if someone_win?

    sc = self.class
    while nc = sc.next_state_class( is_fall? ) 
      break unless nc.allow_orders( map, @areas_states ).empty?
      sc = nc
    end

    next_state._type = nc.name
    next_state.next_date! if nc == State::Move

    next_state.save

    update_sides nc

    game.reload
  end

  def send_websocket
    return if game.waiting?

    WebsocketRails[game.id.to_s].trigger 'state'

    text = "#{date/2}.#{date%2}:#{type}"
    game.messages.create from: 'Dip', is_public: true, text: text
  end

  protected
 
  def next_date!
    self.date += 1
  end

  def gamestate
    @_gamestate || @_gamestate = Engine::Parser::State.new.to_state(data)
  end

  def create_next_state
    state_parser = Engine::Parser::State.new @areas_states
    game.states.build data: state_parser.to_hash, date: date
  end

  def update_orders( resolved_orders )
    powers = {}

    resolved_orders.each do |resolved_order|
      raw = resolved_order.raw
      order = raw[:order]
      power = raw[:power]
      region = raw[:region]

      order['result'] = resolved_order.resolution_readable

      ( powers[power] ||= {} )[region] = order
    end

    update_attributes! resulted_orders: powers

    game.reload.orders.destroy_all
  end

  def update_sides( state_class )
    return unless game.sides.count > 1

    orderable = state_class.allow_orders map, @areas_states

    units = count_units @areas_states
    supplies = count_supplies map.supply_centers, @areas_states

    game.alive_sides.each do |side|
      p = side.power.to_sym

      if units.include?(p) || supplies.include?(p)
        side.update_attributes! orderable: orderable.include?(p)
      else
        side.update_attributes! orderable: false, status: :lose
      end
    end
  end

  def someone_win?
    supply_centers = map.supply_centers
    power_supplies = self.class.count_supplies supply_centers, @areas_states

    power_supplies.values.max > supply_centers.length / 2
  end

  def self.count_units( areas_states )
    units = Hash.new { |h,k| h[k] = 0 }
    areas_states.each do |abbrv, area|
      if unit = area.unit
        units[unit.nationality] += 1
      end
    end
    areas_states.dislodges.each do |abbr, dislodge|
      units[dislodge.unit.nationality] += 1
    end
    units
  end

  def self.count_supplies( supply_centers, areas_states )
    supplies = Hash.new { |h,k| h[k] = 0 }
    supply_centers.each do |abbrv, area|
      if owner = areas_states[abbrv].owner
        supplies[owner] += 1
      end
    end
    supplies
  end
end


class State::Move < State
  RESOLVE_METHOD = :resolve!

  def self.next_state_class( is_fall )
    State::Retreat
  end
  def self.allow_orders( map, areas_states )
    areas_states.map{ |abbr, area| area.unit.try :nationality }
  end
end


class State::Retreat < State
  RESOLVE_METHOD = :resolve_retreats!

  def self.next_state_class( is_fall )
    is_fall ? State::Supply : State::Move
  end
  def self.allow_orders( map, areas_states )
    areas_states.dislodges.map{ |abbr, dislodge| dislodge.unit.nationality }
  end
end


class State::Supply < State
  RESOLVE_METHOD = :resolve_builds!

  def self.next_state_class( is_fall )
    State::Move
  end
  def self.allow_orders( map, areas_states )
    units = count_units areas_states
    supplies = count_supplies map.supply_centers, areas_states

    map.powers.map{ |p| p.to_sym }.select do |power|
      units[power] != supplies[power]
    end
  end
end
