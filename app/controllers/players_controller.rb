class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      redirect_do games_path
    else
      render :games, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :gender, :address, :photo)
  end
end
