class Side
  include Mongoid::Document

  field :power

  embedded_in :game
  belongs_to :user
  
  validates :game, :user, presence: true
  validates :power, inclusion: {in: proc{|s| s.game.powers}}, allow_blank: true
  validate :game_is_waiting, on: :create

  def order
    order_in game.state
  end

  def order_in( state )
    state.order_of self
  end

  protected
  
  def game_is_waiting
    if game.status != 'waiting'
      errors.add :game, 'Game already start'
    end
  end
end
