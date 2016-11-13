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

ActiveRecord::Schema.define(version: 20161112135554) do

  create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "user_id"
    t.text     "activity_details", limit: 65535, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "bills", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",                                           null: false
    t.text     "descrption",   limit: 65535
    t.float    "total_amount", limit: 24,                        null: false
    t.string   "split_method",               default: "equally", null: false
    t.integer  "group_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["group_id"], name: "index_bills_on_group_id", using: :btree
  end

  create_table "debts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "member1",                                 null: false
    t.integer  "member2",                                 null: false
    t.float    "owes_amount",   limit: 24, default: 0.0
    t.boolean  "unregist_mem1",            default: true
    t.boolean  "unregist_mem2",            default: true
    t.integer  "group_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "bill_id"
    t.index ["bill_id"], name: "index_debts_on_bill_id", using: :btree
    t.index ["group_id"], name: "index_debts_on_group_id", using: :btree
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",                      null: false
    t.text     "description", limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["user_id"], name: "index_groups_on_user_id", using: :btree
  end

  create_table "groups_unregist_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "group_id"
    t.integer "unregist_user_id"
    t.index ["group_id", "unregist_user_id"], name: "index_groups_unregist_users_on_group_id_and_unregist_user_id", using: :btree
  end

  create_table "unregist_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",       limit: 25, default: "Anonymous"
    t.string   "email",                 default: ""
    t.boolean  "registered",            default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "username",        limit: 25,              null: false
    t.string   "email",                                   null: false
    t.string   "phone",           limit: 10,              null: false
    t.string   "image",                      default: ""
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "password_digest",                         null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["phone"], name: "index_users_on_phone", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

end
