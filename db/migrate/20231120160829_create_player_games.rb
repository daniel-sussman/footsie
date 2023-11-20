class CreatePlayerGames < ActiveRecord::Migration[7.1]
  def change
    create_table :player_games do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
