class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :public, type: Boolean
  field :to, type: Array
  field :from
  field :text

  embedded_in :game

  validates :text, :from, presence: true, on: :create
  #validate :to_valid_powers, on: :create

  protected

  def to_valid_powers
    powers = game.taken_powers
    if to.empty? && self[:public] != true
      errors.add :to, 'to no one'
    end
    if to.include?(from)
      errors.add :to, 'message to yourself'
    end
    to.each do |power|
      if powers.not_include?(power)
        errors.add :to, "not existing power #{power}"
      end
    end
  end
end
