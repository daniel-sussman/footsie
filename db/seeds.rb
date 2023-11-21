puts "Wiping all players from the database..."

# Player.destroy_all

# puts "Generating 35 new players..."

# 35.times do
#   name = Faker::Sports::Football.player
#   description = "#{Faker::Sports::Football.position}. #{Faker::Quote.mitch_hedberg}"
#   address = Faker::Address.full_address
#   gender = %w[male female].sample
#   Player.create(name: name, description: description, address: address, gender: gender)
# end

puts "Game generation Start."

10.times do
  description = "#{Faker::Sports::Football.position}. #{Faker::Quote.mitch_hedberg}"
  address = Faker::Address.full_address
  gender = %w[male female].sample
  team_size = 12
  pitch_identifier = "pitch number"
  pitch_type =   %w[male female].sample
  starting_date =
  ending_date =
  recurring_rule =
  Games.create(
    description: description,
    address: address,
    gender: gender,
    team_size: team_size,
    pitch_identifier: pitch_identifier,
    pitch_type: pitch_type,
    starting_date: starting_date,
    ending_date: ending_date,
    description: description,
    recurring_rule: recurring_rule,
  )
end
puts "Game generation complete."
