class Game
  include Mongoid::Document
  include Mongoid::Slug

  TIME_MODES = { 
    'sixty_seconds' => 1,
    'five_four_three' => { move: 5, supply: 4, retreat: 3 },
    'half_day' => 720,
    'twenty_four_hours' => 1440,
    'manual' => nil
  }

  field :name
  field :status, default: 'waiting'
  field :is_public, type: Boolean
  field :powers_is_random, type: Boolean
  field :time_mode

  belongs_to :map
  belongs_to :creator, class_name: 'User'
  embeds_many :sides
  embeds_many :states
  embeds_many :messages
  embeds_many :orders

  validates :name, :map, :creator, :time_mode, presence: true
  validates :name, uniqueness: true, format: { with: /\A[\w\-]{5,20}\z/ }
  validates :time_mode, inclusion: { in: TIME_MODES.keys }

  after_create :create_initial_state, :add_creator_side

  slug { |game| game.name }

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
  validate :validate_privacy

  def start_timer
  end

  protected

  def validate_privacy
    if is_public
      errors.add :is_public, 'cannot be public without timing'
    end
  end
end


class Game::Sheduled < Game

  field :secret, default: ->{ SecureRandom.hex(8) }

  def start_timer
    return if game_lefted?

    end_at = get_duration.minutes.from_now
      
    state.update_attribute :end_at, end_at
      
    RestClient.delay( run_at: end_at ).get "http://#{APP_HOST}/games/#{id}/progress", secret: secret
  end

  protected

  def get_duration
    duration = TIME_MODES[ time_mode ]
    duration = duration[ state.type.downcase.to_sym ] if duration.is_a?( Hash )
    duration
  end

  def game_lefted?
    return false unless states.count > 3

    last_three_states = states.desc(:_id).limit(3).skip(1).to_a

    last_three_states.each do |state|
      return false unless state.resulted_orders.empty?
    end

    return true
  end
end
