# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160222062906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lines", force: :cascade do |t|
    t.integer  "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lines", ["song_id"], name: "index_lines_on_song_id", using: :btree

  create_table "patches", force: :cascade do |t|
    t.integer  "version"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "patches", ["version"], name: "index_patches_on_version", unique: true, using: :btree

  create_table "songs", force: :cascade do |t|
    t.string   "beat_link"
    t.string   "name"
    t.string   "author"
    t.string   "singer"
    t.integer  "patch_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "file_name"
    t.string   "lyric"
    t.string   "lyric_link"
    t.string   "waveform_file"
    t.string   "singer_wav"
    t.string   "wave_form_singer"
  end

  add_index "songs", ["file_name"], name: "index_songs_on_file_name", using: :btree
  add_index "songs", ["patch_id"], name: "index_songs_on_patch_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "content"
    t.integer  "note"
    t.integer  "duration"
    t.integer  "processed_at"
    t.integer  "line_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "words", ["line_id"], name: "index_words_on_line_id", using: :btree
  add_index "words", ["note"], name: "index_words_on_note", using: :btree
  add_index "words", ["processed_at"], name: "index_words_on_processed_at", using: :btree

  add_foreign_key "lines", "songs", on_delete: :cascade
  add_foreign_key "songs", "patches", on_delete: :cascade
  add_foreign_key "words", "lines", on_delete: :cascade
end
