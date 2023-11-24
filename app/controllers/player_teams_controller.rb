class PlayerTeamsController < ApplicationController
  def create
    team = Team.find(params[:team_id])
    subscription = PlayerTeam.find_by(team_id: team.id, player_id: current_player.id)
    if subscription
      subscription.active = true
    else
      subscription = PlayerTeam.new(team_id: team.id, player_id: current_player.id)
    end
    subscription.save
    flash[:notice] = "You have joined the #{team.name}!"
    redirect_to game_path(team.game)
  end

  def update
    subscription = PlayerTeam.find(params[:id])
    subscription.active = false
    subscription.save
    team = subscription.team
    redirect_to games_path
    flash[:notice] = "You have left the #{team.name}."
  end
end
