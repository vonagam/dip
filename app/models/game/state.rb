class State
  include Mongoid::Document

  field :data, type: Hash
  field :date, type: Integer
  field :orders_info, type: Hash
  field :sides_info, type: Hash
  field :is_end, type: Boolean

  belongs_to :previous, class_name: 'State'

  embedded_in :game

  delegate :map, to: :game
  delegate :count_units, :count_supplies, to: :class

  def is_fall?
    date % 2 == 1 
  end
  def type
    _type.demodulize
  end
  def previous
    game.states.find previous_id
  end

  def parse_orders( what = nil )
    what ||= game.orders.all.map!{ |x| x.data }.reduce({}, :merge)
    Engine::Parser::Order.new(gamestate).parse_orders what, type
  end

  def create_next
    @areas_states, resolved_order = map.adjudicator.send( 
      self.class::RESOLVE_METHOD, 
      gamestate, 
      parse_orders, 
      is_fall?
    )

    state_class = self.class
    while next_class = state_class.next_state_class is_fall?
      orderable = next_class.allow_orders map, @areas_states
      break unless orderable.empty?
      state_class = next_class
    end

    sides_info, is_end = check_sides orderable

    game.states.create(
      previous_id: self.id,
      data: Engine::Parser::State.new(@areas_states).to_hash,
      date: date + (next_class == State::Move ? 1 : 0),
      orders_info: resolved_to_hash(resolved_order),
      sides_info: sides_info,
      is_end: is_end,
      _type: next_class.name
    )
  end

  def apply_to_game
    game.orders.destroy_all
    game.sides.each{ |side| side.update_attributes sides_info[side.id] }
    if is_end
      game.update_attributes! status: :ended, ended_by: 'win'
    else
      game.update_attributes! status: :going, ended_by: nil
    end
    game.reload
  end

  def self.create_initial_state( game )
    State::Move.create(
      game: self,
      previous_id: nil,
      data: Engine::Parser::State.new(game.map.initial_state).to_hash,
      date: 0,
      orders_info: {},
      sides_info: {},
      is_end: false
    )
  end

  def initial_sides_info
    sides_info = game.sides.each_with_object({}) do |side, hash|
      hash[side.id] = { status: :fighting, orderable: true }
    end
    update_attribute :sides_info, sides_info
  end

  protected

  def self.allowed_powers( powers )
    powers.compact!
    powers.uniq!
    powers.map! &:to_s
    #powers.select{ |power| game.sides.any?{ |side| side.power.include? power } }
  end

  def gamestate
    @_gamestate || @_gamestate = Engine::Parser::State.new.to_state(data)
  end

  def resolved_to_hash( resolved_orders )
    orders = Hash.new({})

    resolved_orders.each do |resolved_order|
      raw = resolved_order.raw
      order = raw[:order]
      power = raw[:power]
      region = raw[:region]

      order['result'] = resolved_order.resolution_readable

      orders[power][region] = order
    end

    orders
  end

  def check_sides( orderable )
    supply_centers = map.supply_centers
    units = count_units @areas_states
    supplies = count_supplies supply_centers, @areas_states

    info = game.sides.each_with_object({}) do |side, hash|
      ps = side.power

      hash[side.id] =
        if ps.any?{ |p| units.include?(p) || supplies.include?(p) }
          { orderable: ps.any?{ |p| orderable.include? p }, status: side.status }
        else
          { orderable: false, status: side.fighting? ? :lost : side.status }
        end
    end

    fighting_sides = info.select{ |k,v| v[:status] == :fighting }

    if game.sides.size > 1 && fighting_sides.size == 1
      winner = fighting_sides.first[0]
    elsif supplies.values.max > supply_centers.length / 2
      winner = game.sides.to_a.find{ |side| side.power.include? supplies.max[0] }.id
    end

    if winner
      fighting_sides.each do |id, info|
        info[:status] = id == winner ? :won : :lost
      end
    end

    info, winner.not_nil?
  end

  def self.count_units( areas_states )
    units = Hash.new 0
    areas_states.each do |abbrv, area|
      if unit = area.unit
        units[unit.nationality.to_s] += 1
      end
    end
    areas_states.dislodges.each do |abbr, dislodge|
      units[dislodge.unit.nationality.to_s] += 1
    end
    units
  end

  def self.count_supplies( supply_centers, areas_states )
    supplies = Hash.new 0
    supply_centers.each do |abbrv, area|
      if owner = areas_states[abbrv].owner
        supplies[owner.to_s] += 1
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
    allowed_powers areas_states.map{ |abbr, area| area.unit.try(:nationality) }
  end
end


class State::Retreat < State
  RESOLVE_METHOD = :resolve_retreats!

  def self.next_state_class( is_fall )
    is_fall ? State::Supply : State::Move
  end
  def self.allow_orders( map, areas_states )
    allowed_powers areas_states.dislodges.map{ |abbr, dislodge| dislodge.unit.nationality }
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

    allowed_powers map.powers.select{ |power| units[power] != supplies[power] }
  end
end
