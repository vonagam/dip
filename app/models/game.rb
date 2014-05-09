class Game
  include Mongoid::Document


  field :status, default: 'waiting'
  field :description


  belongs_to :map
  belongs_to :creator, class_name: 'User'

  embeds_many :sides
  embeds_many :states


  def state
    states.last
  end

  def powers
    map.powers.all.pluck :name
  end
  def taken_powers
    sides.all.collect {|s| s.power.name }
  end
  def available_powers
    powers - taken_powers
  end

  def progress!
    if status == 'waiting'
      randomize_sides
      update_attributes status: 'in_process'
      return
    end

    state.process

    if state.type == 'State'
      update_attributes status: 'ended'
    end
  end

  def user_side(user)
    sides.find_by user_id: user.id
  end

  def randomize_sides
    available = available_powers
    sides.where( power_id: nil ).each do |side|
      side.power = Power.find_by( map_id: map.id, name: available.shuffle.pop )
      side.save
    end
  end

  def is_filled?
    sides.count == map.powers.count
  end

  def orders_received?
    state.orders.count == sides.count
  end
end
