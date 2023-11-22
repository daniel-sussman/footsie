require "faker"
puts "Wiping all players from the database..."
PlayerGame.destroy_all
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
  address = Faker::Travel::TrainStation.name(region: 'united_kingdom', type: 'metro')
  gender = %w[male female co-ed].sample
  team_size = rand(5..11)
  pitch_identifier = "Pitch #{rand(1..9)}"
  pitch_type = %w[grass 3-G astroturf].sample
  starting_date = Faker::Date.on_day_of_week_between(day: :tuesday, from: '2023-12-21', to: '2023-12-30')
  ending_date = Faker::Date.on_day_of_week_between(day: :tuesday, from: '2024-1-01', to: '2024-2-01')
  schedule = IceCube::Schedule.new(now = Time.now)
  schedule.add_recurrence_rule(IceCube::Rule.weekly.day([:saturday, :sunday].sample).hour_of_day(rand(8..18)))
  recurring_rule = schedule.to_yaml

  Game.create!(
    name: name,
    description: description,
    address: address,
    gender: gender,
    team_size: team_size,
    pitch_identifier: pitch_identifier,
    pitch_type: pitch_type,
    starting_date: starting_date,
    ending_date: ending_date,
    recurring_rule: recurring_rule,
    player_id: Player.all.sample.id
  )
end
puts "Game generation complete."

puts "Populating each game with a random number of players..."

Game.all.each do |game|
  capacity = (game.team_size * 2) - 1
  players = (Player.all - [game.player]).shuffle
  rand(0..capacity).times do |index, player_game|
    PlayerGame.create(game_id: game.id, player_id: players[index].id)
  end
end

puts "Game population complete."
