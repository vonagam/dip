class Power
  include Mongoid::Document


  field :name


  embedded_in :map

  has_many :sides
end
