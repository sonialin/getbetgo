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

ActiveRecord::Schema.define(version: 20140829131909) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "bets", force: true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "body"
    t.integer  "status_id"
  end

  add_index "bets", ["post_id"], name: "index_bets_on_post_id", using: :btree
  add_index "bets", ["status_id"], name: "index_bets_on_status_id", using: :btree
  add_index "bets", ["user_id"], name: "index_bets_on_user_id", using: :btree

  create_table "bets_statuses", force: true do |t|
    t.string "name"
  end

  add_index "bets_statuses", ["name"], name: "index_bets_statuses_on_name", using: :btree

  create_table "bootsy_image_galleries", force: true do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: true do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "counties", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "state_country_id"
    t.string   "state_country_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counties", ["name"], name: "index_counties_on_name", using: :btree
  add_index "counties", ["short_name"], name: "index_counties_on_short_name", using: :btree
  add_index "counties", ["state_country_type", "state_country_id"], name: "index_counties_on_state_country_type_and_state_country_id", using: :btree

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], name: "index_countries_on_name", using: :btree
  add_index "countries", ["short_name"], name: "index_countries_on_short_name", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "funds", force: true do |t|
    t.float    "amount"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bet_id"
    t.integer  "user_id"
  end

  add_index "funds", ["bet_id"], name: "index_funds_on_bet_id", using: :btree
  add_index "funds", ["user_id"], name: "index_funds_on_user_id", using: :btree

  create_table "localities", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "administrative_area_id"
    t.string   "administrative_area_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "localities", ["administrative_area_type", "administrative_area_id"], name: "index_localities_on_administrative_area", using: :btree
  add_index "localities", ["name"], name: "index_localities_on_name", using: :btree
  add_index "localities", ["short_name"], name: "index_localities_on_short_name", using: :btree

  create_table "mailboxer_conversation_opt_outs", force: true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  create_table "mailboxer_conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree

  create_table "mailboxer_receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree

  create_table "modification_requests", force: true do |t|
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_id"
    t.integer  "user_id"
  end

  add_index "modification_requests", ["reply_id"], name: "index_modification_requests_on_reply_id", using: :btree
  add_index "modification_requests", ["user_id"], name: "index_modification_requests_on_user_id", using: :btree

  create_table "orders", force: true do |t|
    t.float    "amount"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "bet_id"
    t.string   "token"
    t.float    "credit"
  end

  add_index "orders", ["bet_id"], name: "index_orders_on_bet_id", using: :btree
  add_index "orders", ["post_id"], name: "index_orders_on_post_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "paypal_recipient_accounts", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "paypal_recipient_accounts", ["user_id"], name: "index_paypal_recipient_accounts_on_user_id", using: :btree

  create_table "places", force: true do |t|
    t.string   "google_api_place_id"
    t.integer  "political_id"
    t.string   "political_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["google_api_place_id"], name: "index_places_on_google_api_place_id", using: :btree
  add_index "places", ["political_type", "political_id"], name: "index_places_on_political", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.decimal  "price"
    t.integer  "quantity"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "slug"
    t.string   "location"
    t.string   "service"
    t.integer  "subcategory_id"
    t.string   "criteria"
    t.integer  "status_id"
    t.integer  "place_id"
  end

  add_index "posts", ["place_id"], name: "index_posts_on_place_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  add_index "posts", ["status_id"], name: "index_posts_on_status_id", using: :btree
  add_index "posts", ["subcategory_id"], name: "index_posts_on_subcategory_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "posts_statuses", force: true do |t|
    t.string "name"
  end

  add_index "posts_statuses", ["name"], name: "index_posts_statuses_on_name", using: :btree

  create_table "proofs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "documentable_id"
    t.string   "documentable_type"
  end

  add_index "proofs", ["documentable_id", "documentable_type"], name: "index_proofs_on_documentable_id_and_documentable_type", using: :btree
  add_index "proofs", ["reply_id"], name: "index_proofs_on_reply_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "replies", force: true do |t|
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bet_id"
    t.integer  "user_id"
  end

  add_index "replies", ["bet_id"], name: "index_replies_on_bet_id", using: :btree
  add_index "replies", ["user_id"], name: "index_replies_on_user_id", using: :btree

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id", using: :btree
  add_index "states", ["name"], name: "index_states_on_name", using: :btree
  add_index "states", ["short_name"], name: "index_states_on_short_name", using: :btree

  create_table "subcategories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "subcategories", ["category_id"], name: "index_subcategories_on_category_id", using: :btree
  add_index "subcategories", ["name"], name: "index_subcategories_on_name", using: :btree

  create_table "sublocalities", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "locality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sublocalities", ["locality_id"], name: "index_sublocalities_on_locality_id", using: :btree
  add_index "sublocalities", ["name"], name: "index_sublocalities_on_name", using: :btree
  add_index "sublocalities", ["short_name"], name: "index_sublocalities_on_short_name", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_infos", force: true do |t|
    t.text     "biography"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "location"
    t.string   "linkedin"
    t.string   "twitter"
    t.string   "github"
    t.string   "website"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "user_infos", ["user_id"], name: "index_user_infos_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  create_table "wallets", force: true do |t|
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "wallets", ["user_id"], name: "index_wallets_on_user_id", using: :btree

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", name: "mb_opt_outs_on_conversations_id", column: "conversation_id"

  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", name: "notifications_on_conversation_id", column: "conversation_id"

  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", name: "receipts_on_notification_id", column: "notification_id"

end
