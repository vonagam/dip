class Game
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Enum
  include Mongoid::Timestamps::Created

  TIME_MODES = { 
    '5m' => 5,
    '12h' => 720,
    '1d' => 1440,
    'manual' => nil
  }

  CHAT_MODES = {
    'only_public' => true,
    'only_private' => false,
    'rotation' => proc{ |game| game.state.is_fall? },
    'both' => nil
  }

  field :name
  enum :status, [:waiting, :going, :ended]
  field :ended_by
  field :is_public, type: Boolean
  field :secret, default: ->{ SecureRandom.hex 8 }
  field :time_mode
  field :chat_mode
  field :powers_is_random, type: Boolean
  field :timer_at, type: Time

  belongs_to :map
  belongs_to :creator, class_name: 'User'
  embeds_many :sides
  embeds_many :states
  embeds_many :messages
  embeds_many :orders

  slug :name
  delegate :progress_game_url, to: 'Rails.application.routes.url_helpers'

  validates :name, :is_public, :powers_is_random, :time_mode, :chat_mode, :map, :creator, presence: true
  validates :name, uniqueness: true, format: { with: /\A[\w\-]{5,15}\z/ }
  validates :time_mode, inclusion: { in: TIME_MODES.keys }
  validates :chat_mode, inclusion: { in: CHAT_MODES.keys }

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
    sides.reduce([]){ |sum,side| sum + side.power.to_a }
  end
  def available_powers
    powers - taken_powers
  end

  def chat_is_public?
    answer = CHAT_MODES[chat_mode]
    answer.is_a?(Proc) ? answer.call(self) : answer
  end

  def progress
    return if ended?

    if waiting?
      going!
      fill_sides_powers
      state.initial_sides_info
    else
      state.create_next.apply_to_game
    end

    start_timer if going?
  end

  def rollback
    return unless states.count > 1
    state.destroy
    reload
    state.apply_to_game
  end

  def start_timer( force = false )
    return if time_mode == 'manual' || (!force && is_left?)
    timer_at = TIME_MODES[ time_mode ].minutes.from_now
    update_attribute :timer_at, timer_at
    RestClient.delay(run_at: timer_at).post progress_game_url(self), secret: secret
  end

  def end_by( reason )
    update_attributes! status: :ended, ended_by: reason
  end

  def sandbox?
    going? && sides.count == 1
  end

  def is_left?
    return false if states.count < 4
    last_three_states = states.desc(:_id).limit(3).skip(1).to_a
    last_three_states.any?{ |state| state.resulted_orders.not_empty? }
  end

  protected

  def create_initial_state
    State.create_initial_state self
  end
  
  def add_creator_side
    sides.create user: creator
  end

  def fill_sides_powers
    if sides.count == 1
      sides.first.update_attributes power: map.powers
    else
      available = available_powers
      sides.select{ |s| s.power.blank? }.each do |side|
        side.update_attributes power: [ available.shuffle!.pop ]
      end
    end

    sides.each &:save_name
  end
end
