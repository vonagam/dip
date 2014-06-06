class Game
  include Mongoid::Document

  field :status, default: 'waiting'
  field :description
  field :is_public, type: Boolean
  field :powers_is_random, type: Boolean

  belongs_to :map
  belongs_to :creator, class_name: 'User'
  embeds_many :sides
  embeds_many :states
  embeds_many :messages
  embeds_many :orders

  validates :map, :creator, presence: true

  after_create :create_initial_state, :add_creator_side

  def state
    states.last
  end
  def side_of( user )
    sides.find_by user: user
  end
  def order_of( side )
    orders.find_by side: side
  end

  def powers
    map.powers
  end
  def taken_powers
    sides.only(:power).all.collect!(&:power)
  end
  def alive_powers
    sides.where(alive: true).only(:power).all.collect!(&:power)
  end
  def available_powers
    powers - taken_powers
  end

  def progress!
    return if status == 'finished'

    if status == 'waiting'
      randomize_sides

      update_attributes! status: 'started'

      state.send_websocket
      start_timer

      return
    end

    state.process

    if state._type == 'State'
      update_attributes status: 'finished'
      return
    end

    start_timer
  end

  def randomize_sides
    available = available_powers
    sides.select{ |s| s.power.blank? }.each do |side|
      side.update_attributes power: available.shuffle!.pop
    end
  end

  protected

  def create_initial_state
    start_state = Engine::Parser::State.new map.initial_state
    State::Move.create game: self, data: start_state.to_hash, date: 0
  end
  def add_creator_side
    sides.create user: creator
  end
end


class Game::Manual < Game
  def start_timer
  end
end


class Game::Sheduled < Game
  TYPES = ['Move','Retreat','Supply']

  field :secret
  field :states_durations, type: Hash

  validate :validate_durations

  after_create :fill_secret

  def start_timer
    return if game_lefted?

    duration = states_durations[state.type]

    end_at = duration.minutes.from_now
      
    state.update_attribute :end_at, end_at
      
    RestClient.delay( run_at: end_at ).get "http://#{APP_HOST}/games/#{id}/progress", secret: secret
  end

  protected

  def validate_durations
    if states_durations.keys.length != 3
      errors.add :states_durations, 'wrong number of states types'
      return
    end

    if ( states_durations.keys - Game::Sheduled::TYPES ).not_empty?
      errors.add :states_durations, 'not all types specified'
      return
    end

    states_durations.each do |type, duration|
      if duration.not_is?(Integer)
        errors.add :states_durations, 'not integer'
      end
      if duration < 0 || duration > 1440
        errors.add :states_durations, 'must be between 1 and 1440 minutes'
      end
    end
  end

  def fill_secret
    self.update_attribute :secret, SecureRandom.hex(8)
  end

  def game_lefted?
    return unless states.count > 3

    last_three_states = states.desc(:_id).limit(3).skip(1).to_a

    last_three_states.each do |state|
      return false unless state.resulted_orders.empty?
    end

    return true
  end
end
