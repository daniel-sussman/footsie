class PlayerGamesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @join = PlayerGame.new(game_id: @game.id, player_id: current_player.id)
    @join.save
    redirect_to game_path(@game)
  end
end
