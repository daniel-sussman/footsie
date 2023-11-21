require "faker"
puts "Wiping all players from the database..."
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

puts "Game generation Start."
Game.destroy_all

20.times do
  name = Faker::Game.title
  description = "#{Faker::Sports::Football.position}. #{Faker::Quote.mitch_hedberg}"
  address = Faker::Games::HalfLife.location
  gender = %w[male female].sample
  team_size = Random.new.rand(5..11)
  pitch_identifier = "pitch number"
  pitch_type =   %w[grass 3-G astroturf].sample
  starting_date = Faker::Date.on_day_of_week_between(day: :tuesday, from: '2023-12-21', to: '2023-12-30')
  ending_date = Faker::Date.on_day_of_week_between(day: :tuesday, from: '2024-1-01', to: '2024-2-01')
  schedule = IceCube::Schedule.new(now = Time.now)
  schedule.add_recurrence_rule(IceCube::Rule.weekly.day([:saturday, :sunday].sample).hour_of_day(Random.new.rand(8..18)))
  recurring_rule = schedule.to_yaml

  Game.create(
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
