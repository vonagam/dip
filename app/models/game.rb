class Game < ActiveRecord::Base
  #attr_accessible :name, :status

  has_many :sides, dependent: :destroy
  has_many :states, dependent: :destroy

  has_many :users, through: :sides

  validates :name, presence: true
  
  after_create :initial_state

  def initial_state
    state_parser = Diplomacy::StateParser.new MAP_READER.maps['Standard'].starting_state

    State::Move.create game_id: id, data: state_parser.dump_state, date: 0

    update_attributes! status: 'waiting'
  end

  def powers
    MAP_READER.maps['Standard'].powers.keys
  end
  def available_powers
    powers - sides.collect {|s| s.name }
  end

  def progress!
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
