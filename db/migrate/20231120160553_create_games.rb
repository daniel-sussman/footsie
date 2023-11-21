class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :name
      t.text :description
      t.string :gender
      t.integer :team_size
      t.string :pitch_identifier
      t.string :pitch_type
      t.string :address
      t.date :starting_date
      t.date :ending_date
      t.text :recurring_rule
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
