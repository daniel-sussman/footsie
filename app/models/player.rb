class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :player_games
  has_many :games, through: :player_games
  has_many :reviews, dependent: :destroy
  has_one_attached :photo

  validates :name, :address, presence: true
  validates :gender, presence: true, inclusion: { in: %w[male female] }
end
