class Game < ApplicationRecord
  # Check Player id from player table
  belongs_to :player
  has_many :players , through: :player_games
  # Add Validation table field base role
  validates_associated :players
  validates :description, presence: true
  validates :address, presence: true
  validates :gender, acceptance: { accept: ['male', 'female'] }
  validates :team_size, numericality: { only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to:11 }
  validates :pitch_type, presence: true
  validates :starting_date, presence: true
  validates :ending_date, comparison: { greater_than: :starting_date }
  validates :recurring_rule, presence: true
end
