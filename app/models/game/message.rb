class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :public, type: Boolean
  field :to, type: Array
  field :from
  field :text

  embedded_in :game

  validates :text, :to, :from, presence: true, on: :create
  validate :to_valid_powers, on: :create

  protected

  def to_valid_powers
    powers = game.taken_powers
    if to.empty?
      errors.add :to, 'to no one'
    end
    to.each do |power|
      errors.add :to, 'not existing power' unless powers.include?(power)
    end
  end
end
