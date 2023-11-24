class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit destroy]
  skip_before_action :authenticate_player!, only: %i[index show search]

  def index
    @games = Game
      .all
      .reject { |game| closed?(game) }
      .sort_by { |game| game.updated_at }
      .reverse
    @open_games = @games.reject { |game| closed?(game) }
  end

  def search
    if params[:query].present?
      location = "#{params[:query]}, London, United Kingdom"
      results = Geocoder.search(location)
      @coords = results.first.coordinates

      @games = Game.all.sort_by { |g| g.distance_to(@coords)}
      @open_games = @games.reject { |g| closed?(g) }

      @markers = Game.all.geocoded.map do |game|
        {
          lat: game.latitude,
          lng: game.longitude,
          info_card_html: render_to_string(partial: "info_card", locals: { game: game }),
          marker_html: render_to_string(partial: "marker_#{color_code(game)}")
        }
      end
    else
      @games = Game
      .all
      .reject { |game| closed?(game) }
      .sort_by { |game| game.updated_at }
      .reverse
      @nono = true
      render 'games/index'
    end
  end

  def show
    @game = Game.find(params[:id])
    @games = Game.all
    @review = Review.new
    @players = game_active_players(@game)
    if player_signed_in?
      @player = current_player
      @status = fetch_player_status
      @my_team = @game.teams[0] if team_active_players(@game.teams[0]).include?(current_player)
      @my_team = @game.teams[1] if team_active_players(@game.teams[1]).include?(current_player)
      @player_team = PlayerTeam.find_by(player_id: current_player, team_id: @my_team.id) if @my_team
    else
      @status = "login"
    end
    @open_games = @games.reject { |game| closed?(game) }
    @markers = @games.geocoded.map do |game|
      {
        lat: game.latitude,
        lng: game.longitude
      }
    end
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.player = current_player

    if @game.save
      set_recurrence_rule(@game)
      red_team = Team.create(name: @game.red_team_name, game_id: @game.id)
      PlayerTeam.create(player_id: current_player.id, team_id: red_team.id)
      Team.create(name: @game.blue_team_name, game_id: @game.id)

      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @game.update(game_params)
    redirect_to game_path(@game)
  end

  def destroy
    @game.destroy
    redirect_to games_path, status: :see_other
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name, :description, :red_team_name, :blue_team_name, :price, :gender, :team_size, :pitch_identifier, :pitch_type, :indoor, :address, :starting_date, :ending_date, :day_of_week, :start_time, :photo)
  end

  def active?(game)
    return false unless player_signed_in?

    game_active_players(game).include?(current_player)
  end

  def closed?(game)
    if player_signed_in?
      full?(game) || wrong_gender?(game)
    else
      full?(game)
    end
  end

  def game_active_players(game)
    players = []
    game.teams.each do |team|
      players.concat(team_active_players(team))
    end
    players
  end

  def team_active_players(team)
    PlayerTeam.where(team_id: team.id, active: true).map(&:player)
  end

  def full?(game)
    game_active_players(game).count >= game.team_size * 2
  end

  def team_full?(team)
    team_active_players(team).count >= team.game.team_size
  end

  def wrong_gender?(game)
    game.gender != "co-ed" && game.gender != current_player.gender
  end

  def color_code(game)
    if closed?(game)
      "grey"
    elsif active?(game)
      "orange"
    else
      "blue"
    end
  end

  def fetch_player_status
    if @game.player == @player
      "owner"
    elsif game_active_players(@game).include?(current_player)
      "member"
    elsif wrong_gender?(@game)
      "wrong_gender"
    elsif full?(@game)
      "full"
    else
      "join"
    end
  end

  def set_recurrence_rule(game)
    start_time = DateTime.new(game.starting_date.year, game.starting_date.month, game.starting_date.day, game.start_time.hour, game.start_time.min)
    rule = IceCube::Rule.weekly.day(game.day_of_week.downcase.to_sym).hour_of_day(start_time.hour).minute_of_hour(start_time.min).until(game.ending_date + 1)
    schedule_to_yaml(game, rule)
    # self.recurrence_rule = rule
  end

  def schedule_to_yaml(game, rule)
    raise
    game.recurrence_rule = rule.to_yaml
  end

  def yaml_to_schedule(game)
    hash = Psych.safe_load(game.recurrence_rule, permitted_classes: [Time, Symbol])
    IceCube::Schedule.from_hash(hash)
  end
end

# IceCube::Schedule.new(now = Time.now)
# schedule.add_recurrence_rule(IceCube::Rule.weekly.day(:saturday).hour_of_day(10, 11))
