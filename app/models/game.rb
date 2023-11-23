class Game < ApplicationRecord
  belongs_to :player
  has_many :player_games, dependent: :destroy
  has_many :players, through: :player_games
  has_many :reviews, dependent: :destroy
  has_one_attached :photo

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  validates :description, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :gender, acceptance: { accept: ['male', 'female', 'co-ed'] }
  validates :team_size, numericality: { only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 11 }
  validates :pitch_type, presence: true, inclusion: { in: %w[grass 3-G astroturf] }
  validates :starting_date, presence: true
  validates :ending_date, comparison: { greater_than: :starting_date }
  validates :recurring_rule, presence: true
end
