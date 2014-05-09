class Map
  include Mongoid::Document

  field :name

  has_many :games, dependent: :destroy

  def info
    MAP_READER.maps[ self.name ]
  end
end
