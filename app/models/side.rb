class Side < ActiveRecord::Base
  #attr_accessible :name

  belongs_to :game

  has_many :orders, dependent: :destroy
end
