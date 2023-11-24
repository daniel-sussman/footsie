class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :name
      t.text :description
      t.string :red_team_name
      t.string :blue_team_name
      t.float :price, default: 0.0
      t.string :gender
      t.integer :team_size
      t.string :pitch_identifier
      t.string :pitch_type
      t.boolean :indoor, default: false
      t.string :address
      t.date :starting_date
      t.date :ending_date
      t.string :day_of_week
      t.time :start_time
      t.text :recurrence_rule
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
