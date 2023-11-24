class CreatePlayerGames < ActiveRecord::Migration[7.1]
  def change
    create_table :player_teams do |t|
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
