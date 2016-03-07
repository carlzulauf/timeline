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

ActiveRecord::Schema.define(version: 20160307064105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "credential_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "authentications", ["credential_id"], name: "index_authentications_on_credential_id", using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "authorizations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "credential_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "authorizations", ["credential_id"], name: "index_authorizations_on_credential_id", using: :btree
  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.integer  "credential_id"
    t.string   "tweet_id"
    t.json     "info"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tweets", ["credential_id"], name: "index_tweets_on_credential_id", using: :btree
  add_index "tweets", ["tweet_id"], name: "index_tweets_on_tweet_id", using: :btree

  create_table "twitter_credentials", force: :cascade do |t|
    t.string   "twitter_id"
    t.string   "twitter_nickname"
    t.string   "token"
    t.string   "secret"
    t.json     "auth_hash"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "last_tweet_id"
  end

  add_index "twitter_credentials", ["twitter_id"], name: "index_twitter_credentials_on_twitter_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
