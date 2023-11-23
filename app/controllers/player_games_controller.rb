class PlayerGamesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    subscription = PlayerGame.find_by(game_id: @game.id, player_id: current_player.id)
    if subscription
      subscription.active = true
    else
      subscription = PlayerGame.new(game_id: @game.id, player_id: current_player.id)
    end
    subscription.save
    flash[:notice] = "You have joined the game: #{@game.name}!"
    redirect_to game_path(@game)
  end

  def update
    subscription = PlayerGame.find(params[:id])
    subscription.active = false
    subscription.save
    game = Game.find(subscription.game_id)
    redirect_to games_path
    flash[:notice] = "You have left the game: #{game.name}."
  end
end
