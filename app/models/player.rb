class Player < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :games, through: :player_games

  validates :name, :address, presence: true
  validates :gender, presence: true, inclusion: {in: %w(male female)}
end
