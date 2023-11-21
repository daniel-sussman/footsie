class RemoveTitleFromGames < ActiveRecord::Migration[7.1]
  def change
    remove_column :games, :title, :string
  end
end
