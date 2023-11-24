class PlayersController < ApplicationController
  def show
    if params[:id] == "sign_out"
      redirect_to games_path
    else
      @player = current_player
      @host_games = Game.where("player_id = #{@player.id}")
      @player_teams = PlayerTeam.where("player_id = #{@player.id} AND active = true")
      @past_games = PlayerTeam.where("player_id = #{@player.id} AND active = false").map(&:game)
    end
  end

  def new
    @player = Player.new
  end

  private

  def player_params
    params.require(:player).permit(:name, :gender, :address, :photo)
  end
end
