class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :is_public, type: Boolean
  field :to
  field :from
  field :text

  embedded_in :game

  validates :text, :from, presence: true, on: :create
  validate :to_valid_powers, on: :create

  before_validation :check_status_if_choosable, :delete_to_if_public, on: :create

  protected

  def delete_to_if_public
    self.to = nil if is_public
    true
  end

  def check_status_if_choosable
    if is_public.nil? && game.chat_is_public?.nil?
      self.is_public = to == 'Public'
    end
    true
  end

  def to_valid_powers
    return if is_public

    error = 
    if to.blank?
      :no_one
    elsif to == from
      :yourself
    elsif game.sides.fighting.map(&:name).not_include?(to)
      :not_alive
    end

    errors.add :to, error if error
  end
end
