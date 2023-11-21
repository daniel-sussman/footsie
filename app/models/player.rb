class Player < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :player_games
  has_many :games, through: :player_games
  has_one_attached :photo

  validates :name, :address, presence: true
  validates :gender, presence: true, inclusion: { in: %w[male female] }
end
