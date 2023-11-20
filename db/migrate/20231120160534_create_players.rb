class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :description
      t.string :name
      t.string :address
      t.string :gender

      t.timestamps
    end
  end
end
