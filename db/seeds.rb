def set_recurrence_rule(game)
  start_time = DateTime.new(game.starting_date.year, game.starting_date.month, game.starting_date.day, game.start_time.hour, game.start_time.min)
  raise
  rule = IceCube::Rule.weekly.day(game.day_of_week.downcase.to_sym).hour_of_day(start_time.hour).minute_of_hour(start_time.min).until(game.ending_date + 1)
  schedule_to_yaml(game, rule)
  # self.recurrence_rule = rule
end

def schedule_to_yaml(game, rule)
  game.recurrence_rule = rule.to_yaml
end

def yaml_to_schedule(game)
  hash = Psych.safe_load(game.recurrence_rule, permitted_classes: [Time, Symbol])
  IceCube::Schedule.from_hash(hash)
end

require "faker"
puts "Wiping all players from the database..."
PlayerTeam.destroy_all
Player.destroy_all

puts "Generating 35 new players..."

35.times do
  name = Faker::Sports::Football.player
  description = "#{Faker::Sports::Football.position}. #{Faker::Quote.mitch_hedberg}"
  address = Faker::Address.full_address
  gender = %w[male female].sample
  email = Faker::Internet.email
  Player.create(name: name, description: description, address: address, gender: gender, email: email, password: '123456')
end

puts "Wiping all games from the database..."

Game.destroy_all

puts "Game generation Start."

20.times do
  name = Faker::Sports::Football.competition
  description = "#{Faker::Sports::Football.coach}#{Faker::Sports::Football.position}. #{Faker::Quote.mitch_hedberg}"
  red_team_name = "#{Faker::Creature::Animal.name}s"
  blue_team_name = "#{Faker::Creature::Animal.name}s"
  address = Faker::Travel::TrainStation.name(region: 'united_kingdom', type: 'metro')
  gender = %w[male female co-ed].sample
  team_size = rand(5..11)
  pitch_identifier = "Pitch #{rand(1..9)}"
  pitch_type = %w[grass 3-G astroturf].sample
  starting_date = Faker::Date.on_day_of_week_between(day: :tuesday, from: '2023-11-10', to: '2023-12-30')
  ending_date = Faker::Date.on_day_of_week_between(day: :tuesday, from: '2024-1-01', to: '2024-2-01')
  day_of_week = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].sample
  start_time = Time.new(2023, 12, 1, rand(8..18), [0, 30].sample)

  new_game = Game.create!(
    name: name,
    description: description,
    red_team_name: red_team_name,
    blue_team_name: blue_team_name,
    address: address,
    gender: gender,
    team_size: team_size,
    pitch_identifier: pitch_identifier,
    pitch_type: pitch_type,
    starting_date: starting_date,
    ending_date: ending_date,
    day_of_week: day_of_week,
    start_time: start_time,
    player_id: Player.all.sample.id
  )

  @game = new_game
  set_recurrence_rule(@game)
  red_team = Team.create(name: red_team_name, game_id: new_game.id)
  Team.create(name: blue_team_name, game_id: new_game.id)
  PlayerTeam.create(player_id: new_game.player_id, team_id: red_team.id)
end

puts "Game generation complete."

puts "Populating red teams and blue teams..."

Team.all.each do |team|
  capacity = team.game.team_size - team.player_teams.size
  players = (Player.all - [team.game.player]).shuffle
  rand(0..capacity).times do |index|
    PlayerTeam.create(team_id: team.id, player_id: players[index].id)
  end
end

puts "Teams are formed. Let's play ball!"
