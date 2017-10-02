# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171001231713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", id: :serial, force: :cascade do |t|
    t.date "start_date"
    t.time "start_time"
    t.integer "home_id"
    t.integer "home_rank"
    t.integer "home_score"
    t.integer "away_id"
    t.integer "away_rank"
    t.integer "away_score"
    t.string "location"
    t.integer "week"
    t.integer "status"
    t.string "link"
  end

  create_table "leagues", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "password_digest"
    t.datetime "created_at"
    t.integer "creator_id"
  end

  create_table "leagues_users", id: :serial, force: :cascade do |t|
    t.integer "league_id"
    t.integer "user_id"
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.integer "year"
    t.integer "team_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "stats", id: :serial, force: :cascade do |t|
    t.integer "pass_attempts"
    t.integer "pass_completions"
    t.integer "pass_yards"
    t.integer "pass_touchdowns"
    t.integer "interceptions"
    t.integer "rush_attempts"
    t.integer "rush_yards"
    t.integer "rush_touchdowns"
    t.integer "receptions"
    t.integer "receiving_yards"
    t.integer "receiving_touchdowns"
    t.integer "kicker_points"
    t.integer "predicted"
    t.integer "player_id"
    t.integer "game_id"
    t.index ["game_id"], name: "index_stats_on_game_id"
    t.index ["player_id"], name: "index_stats_on_player_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "short_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
