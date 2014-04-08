class Game < ActiveRecord::Base
  # :name, :status, :description

  has_many :sides, dependent: :destroy
  has_many :states, dependent: :destroy

  has_many :users, through: :sides

  validates :name, presence: true

  belongs_to :creator, class_name: 'User'
  
  after_create :initial_state

  def initial_state
    start_state = Diplomacy::Parser::State.new( MAP_READER.maps['Standard'].starting_state ).to_json

    State::Move.create game_id: id, data: start_state, date: 0

    update_attributes! status: 'waiting'
  end

  def powers
    MAP_READER.maps['Standard'].powers
  end
  def taken_powers
    sides.all.collect {|s| s.name }
  end
  def available_powers
    powers - taken_powers
  end

  def progress!
    return if status == 'ended'

    if status == 'waiting'
      update_attributes! status: 'in_process'
      return
    end

    states.last.process

    if states.last.type == 'State'
      update_attributes! status: 'ended'
    end
  end

  def orders_received?
    states.last.orders.count == sides.count
  end
end
