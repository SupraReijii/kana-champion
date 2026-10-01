# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_01_101714) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "game_name", null: false
    t.decimal "points", precision: 5, scale: 2
    t.decimal "time", precision: 5, scale: 2
    t.integer "kana_count"
    t.integer "kana_right"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kanas", force: :cascade do |t|
    t.string "kana", null: false
    t.string "translation", null: false
    t.integer "times_played", default: 0
    t.integer "times_won", default: 0
    t.string "kana_type", default: "hiragana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
