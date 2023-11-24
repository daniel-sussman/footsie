name_array = [
  "Gary's Saturday Kickabout",
  "Footy with Han in Hackney",
  "Manoj's Football Mastery",
  "Soccer with Suhoan in Stokey",
  "Charlotte's cross-bar challenge",
  "Dalston FC training",
  "Hakcney Hackers 5-aside",
  "David Beckham's freekick classes"
]

park_array = [
  "Regent's Park, London",
  "Hackney Downs, London",
  "Hyde Park, London",
  "Ruskin Park, London",
  "Duliwch Sports Ground, London",
  "Shoredtich Park, London",
  "Belsize Park, London",
  "Clapham Common, London",
  "South Parks, London"
]

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
  name = name_array.sample
  description = "#{Faker::Sports::Football.coach} will play #{Faker::Sports::Football.position}. #{Faker::Quote.mitch_hedberg}."
  red_team_name = "#{Faker::Creature::Animal.name}s"
  blue_team_name = "#{Faker::Creature::Animal.name}s"
  address = park_array.sample
  gender = %w[male female co-ed].sample
  team_size = rand(5..11)
  pitch_identifier = "Pitch #{rand(1..9)}"
  pitch_type = %w[grass 3-G astroturf].sample

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
    price: price,
    player_id: Player.all.sample.id
  )

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
