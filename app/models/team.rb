class Team < ApplicationRecord
  belongs_to :game
  has_many :player_teams
  has_many :players, through: :player_teams
end
