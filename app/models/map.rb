class Map
  include Mongoid::Document


  field :name
  field :areas
  field :initial_state


  embeds_many :powers

  has_many :games
end
