require 'engine/adjudicator/adjudicator'

class Map
  include Mongoid::Document

  field :name

  has_many :games, dependent: :destroy

  def info
    MAP_READER.maps[ self.name ]
  end

  def adjudicator
    Engine::Adjudicator.new info
  end

  delegate :initial_state, :powers, :supply_centers, to: :info
end
