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

ActiveRecord::Schema[8.0].define(version: 2025_06_24_111057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "blurbs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "blurbable_type"
    t.integer "blurbable_id"
    t.boolean "starred", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blurbable_type", "blurbable_id"], name: "index_blurbs_on_blurbable_type_and_blurbable_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "eventable_type", null: false
    t.bigint "eventable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
  end

  create_table "figures", force: :cascade do |t|
    t.string "title"
    t.bigint "sport_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "summary"
    t.date "birth_date"
    t.date "death_date"
    t.index ["sport_id"], name: "index_figures_on_sport_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "picturable_type", null: false
    t.bigint "picturable_id", null: false
    t.string "caption"
    t.string "image_url"
    t.string "storage_key"
    t.boolean "cover", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picturable_type", "picturable_id"], name: "index_pictures_on_picturable_type_and_picturable_id"
  end

  create_table "relationship_figures", force: :cascade do |t|
    t.bigint "figure_id", null: false
    t.bigint "relationship_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["figure_id"], name: "index_relationship_figures_on_figure_id"
    t.index ["relationship_id"], name: "index_relationship_figures_on_relationship_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sport_rules", force: :cascade do |t|
    t.string "title"
    t.text "summary"
    t.text "body"
    t.bigint "sport_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sport_id"], name: "index_sport_rules_on_sport_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "title"
    t.bigint "sport_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sport_id"], name: "index_sports_on_sport_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "storyable_type", null: false
    t.bigint "storyable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["storyable_type", "storyable_id"], name: "index_stories_on_storyable"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "tagable_type", null: false
    t.bigint "tagable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["tagable_type", "tagable_id"], name: "index_taggings_on_tagable"
  end

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "figures", "sports"
  add_foreign_key "relationship_figures", "figures"
  add_foreign_key "relationship_figures", "relationships"
  add_foreign_key "sport_rules", "sports"
  add_foreign_key "sports", "sports"
  add_foreign_key "taggings", "tags"
end
