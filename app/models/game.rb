class Game < ActiveRecord::Base
  # :status, :description

  has_many :sides, dependent: :destroy
  has_many :states, dependent: :destroy

  has_many :users, through: :sides

  belongs_to :creator, class_name: 'User'
  
  after_create :initial_state

  enum status: [ :waiting, :in_process, :ended ]


  def initial_state
    start_state = Diplomacy::Parser::State.new( MAP_READER.maps['Standard'].starting_state ).to_json

    State::Move.create game_id: id, data: start_state, date: 0

    update! status: :waiting
  end

  def powers
    MAP_READER.maps['Standard'].powers
  end
  def taken_powers
    sides.to_a.collect {|s| s.name }
  end
  def available_powers
    powers - taken_powers
  end

  def progress!
    return if ended?

    return in_process! if waiting?

    states.last.process

    ended! if states.last.type == 'State'
  end

  def user_participate?(user)
    users.pluck(:id).include? user.id
  end

  def is_filled?
    users.count == powers.size
  end

  def orders_received?
    states.last.orders.count == sides.count
  end
end
