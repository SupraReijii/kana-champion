class RenameType < ActiveRecord::Migration[8.1]
  def change
    rename_column :kanas, :type, :kana_type
  end
end
