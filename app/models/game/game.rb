class Game
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Enum

  TIME_MODES = { 
    'sixty_seconds' => 1,
    'five_four_three' => { move: 5, supply: 4, retreat: 3 },
    'half_day' => 720,
    'twenty_four_hours' => 1440,
    'manual' => nil
  }

  CHAT_MODES = {
    'public' => true,
    'private' => false,
    'rotation' => proc{ |game| game.state.is_fall? },
    'both' => nil
  }

  field :name
  enum :status, [:waiting, :going, :ended]
  field :is_public, type: Boolean
  field :secret, default: ->{ SecureRandom.hex(8) }
  field :ended_by
  field :time_mode
  field :chat_mode
  field :powers_is_random, type: Boolean

  belongs_to :map
  belongs_to :creator, class_name: 'User'
  embeds_many :sides
  embeds_many :states
  embeds_many :messages
  embeds_many :orders

  delegate :progress_game_url, to: 'Rails.application.routes.url_helpers'

  validates :name, :is_public, :powers_is_random, :time_mode, :chat_mode, :map, :creator, presence: true
  validates :name, uniqueness: true, format: { with: /\A[\w\-]{5,20}\z/ }
  validates :time_mode, inclusion: { in: TIME_MODES.keys }
  validates :chat_mode, inclusion: { in: CHAT_MODES.keys }
  validate :if_manual_then_private

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

  def alive_sides
    sides.fighting.to_a + sides.draw.to_a
  end

  def powers
    map.powers
  end
  def taken_powers
    sides.only(:power).all.collect!(&:power)
  end
  def alive_powers
    sides.fighting.only(:power).all.collect!(&:power)
  end
  def available_powers
    powers - taken_powers
  end

  def chat_is_public?
    answer = CHAT_MODES[ chat_mode ]
    answer.is_a?( Proc ) ? answer.call( self ) : answer
  end

  def progress!
    return if ended?

    if waiting?
      going!

      randomize_sides

      state.send_websocket
      start_timer

      return
    end

    state.process

    if state._type == 'State'
      end_by 'win'
      return
    end

    start_timer
  end

  def start_timer( force = false )
    return if time_mode == 'manual' || ( !force && is_left? )

    end_at = get_duration.minutes.from_now
      
    state.update_attribute :end_at, end_at

    RestClient.delay( run_at: end_at ).get progress_game_url( self, secret: secret )
  end

  def end_by( reason )
    update_attributes! status: :ended, ended_by: reason
  end

  protected

  def if_manual_then_private
    if time_mode == 'manual' && is_public 
      errors.add :is_public, :cant_be_manual
    end
  end

  def create_initial_state
    start_state = Engine::Parser::State.new map.initial_state
    State::Move.create game: self, data: start_state.to_hash, date: 0
  end
  def add_creator_side
    sides.create user: creator
  end

  def get_duration
    duration = TIME_MODES[ time_mode ]
    duration = duration[ state.type.downcase.to_sym ] if duration.is_a?( Hash )
    duration
  end

  def randomize_sides
    available = available_powers
    sides.select{ |s| s.power.blank? }.each do |side|
      side.update_attributes power: available.shuffle!.pop
    end
  end

  def is_left?
    return false if states.count < 4

    last_three_states = states.desc(:_id).limit(3).skip(1).to_a

    last_three_states.each do |state|
      return false unless state.resulted_orders.empty?
    end

    return true
  end
end
