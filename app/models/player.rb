class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :player_teams, dependent: :destroy
  has_many :teams, through: :player_teams
  has_many :games, through: :teams
  has_many :reviews, dependent: :destroy
  has_one_attached :photo

  before_destroy :remove_from_games

  private

  def remove_from_games
    Game.where("player_id = #{self.id}").destroy_all
    Game.all.each do |game|
      game.players.delete(self)
    end
    PlayerTeam.where("player_id = #{self.id}").destroy_all
  end

  validates :name, :address, presence: true
  validates :gender, presence: true, inclusion: { in: %w[male female] }
end
