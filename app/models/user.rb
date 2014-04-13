class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise(
    :database_authenticatable,
    :registerable,
    #:recoverable,
    #:rememberable,
    #:trackable,
    #:validatable
  )


  has_many :sides

  has_many :participated_games, class_name: 'Game', through: :sides

  has_many :created_games, class_name: 'Game', foreign_key: 'creator_id', inverse_of: :creator


  validates :name, :email, :password, presence: true

  validates :name, :email, uniqueness: { case_insensitive: true }
end
