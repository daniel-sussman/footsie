class PlayerTeam < ApplicationRecord
  belongs_to :team
  belongs_to :player

  def game
    team.game
  end
end
