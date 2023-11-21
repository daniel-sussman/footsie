class PlayersController < ApplicationController
  def show
    if params[:id] == "sign_out"
      redirect_to games_path
    else
      @player = Player.find(params[:id])
      @player_games = PlayerGame.where("player_id = #{@player.id} AND active = true")
    end
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      redirect_to games_path
    else
      render :games, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :gender, :address, :photo)
  end
end
