class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :game_name, null: false
      t.integer :points
      t.integer :time
      t.integer :kana_count
      t.integer :kana_right
      t.timestamps
    end
  end
end
