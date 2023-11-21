class AddTitleToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :title, :string
  end
end
