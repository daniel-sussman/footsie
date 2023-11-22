class AddDetailsToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :name, :string
    add_column :games, :indoor, :boolean
    add_column :games, :price, :float
  end
end
