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
    @review = Review.new
    @players = @game.players.select{ |player| PlayerGame.find_by(game_id: @game.id, player_id: player.id).active }
    if player_signed_in?
      @player = current_player
      @player_game = PlayerGame.where("game_id = #{@game.id} AND player_id = #{@player.id}").last
      @status = fetch_player_status
    else
      @status = "login"
    end
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.player = current_player
    if @game.save
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
    params.require(:game).permit(:name, :description, :price, :gender, :team_size, :pitch_identifier, :pitch_type, :indoor, :address, :starting_date, :ending_date, :recurring_rule, :photo)
  end

  def active?(game)
    return false unless player_signed_in?

    game.player == current_player || game.players.include?(current_player)
  end

  def closed?(game)
    if player_signed_in?
      full?(game) || wrong_gender?(game)
    else
      full?(game)
    end
  end

  def full?(game)
    game
      .players
      .select { |player| PlayerGame.find_by(game_id: game.id, player_id: player.id).active }
      .size >= (game.team_size * 2) - 1
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
    elsif @players.include?(@player)
      "member"
    elsif wrong_gender?(@game)
      "wrong_gender"
    elsif full?(@game)
      "full"
    else
      "join"
    end
  end

  def schedule_to_yaml(game, schedule)
    game.recurring_rule = schedule.to_yaml
  end

  def yaml_to_schedule(game)
    hash = Psych.safe_load(game.recurring_rule, permitted_classes: [Time, Symbol])
    IceCube::Schedule.from_hash(hash)
  end
end

# IceCube::Schedule.new(now = Time.now)
# schedule.add_recurrence_rule(IceCube::Rule.weekly.day(:saturday).hour_of_day(10, 11))
