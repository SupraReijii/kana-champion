class CreateKanas < ActiveRecord::Migration[8.1]
  def change
    create_table :kanas do |t|
      t.string :kana, null: false
      t.string :translation, null: false
      t.integer :times_played, default: 0
      t.integer :times_won, default: 0
      t.string :type, default: 'hiragana'
      t.timestamps
    end
  end
end
