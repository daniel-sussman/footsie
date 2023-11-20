puts "Wiping all players from the database..."

Player.destroy_all

puts "Generating 35 new players..."

35.times do
  name = Faker::Sports::Football.player
  description = "#{Faker::Sports::Football.position}. #{Faker::Quote.mitch_hedberg}"
  address = Faker::Address.full_address
  gender = %w[male female].sample
  Player.create(name: name, description: description, address: address, gender: gender)
end

puts "Player generation complete."
