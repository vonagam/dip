class Game
  include Mongoid::Document

  field :status, default: 'waiting'
  field :description

  belongs_to :map
  belongs_to :creator, class_name: 'User'
  embeds_many :sides
  embeds_many :states

  validates :map, :creator, presence: true

  after_create :initial_state
  def initial_state
    start_state = Diplomacy::Parser::State.new( map.info.starting_state ).to_json
    State::Move.create game: self, data: start_state, date: 0

    add_side creator
  end

  def state
    states.last
  end

  def add_side( user, power = nil )
    sides.create user: user, power: power
  end

  def powers
    map.info.powers
  end
  def taken_powers
    sides.only(:power).all.collect!{ |s| s.power }
  end
  def available_powers
    powers - taken_powers
  end

  def progress!
    if status == 'waiting'
      randomize_sides
      update_attributes! status: 'in_process'
      return
    end

    state.process

    if state._type == 'State'
      update_attributes status: 'ended'
    end
  end

  def side_of( user )
    sides.find_by user: user
  end

  def randomize_sides
    available = available_powers
    sides.select{ |s| s.power.blank? }.each do |side|
      side.update_attributes power: available.shuffle.pop
    end
  end

  def is_filled?
    sides.count == map.info.powers.size
  end

  def orders_received?
    state.orders.count == sides.count
  end
end
