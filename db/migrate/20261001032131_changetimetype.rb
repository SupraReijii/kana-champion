class Changetimetype < ActiveRecord::Migration[8.1]
  def change
    change_column :games, :points, :decimal, precision: 5, scale: 2
  end
end
