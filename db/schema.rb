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

ActiveRecord::Schema[7.0].define(version: 2023_10_08_220051) do
  create_table "entities", force: :cascade do |t|
    t.string "name"
    t.integer "naics_code"
    t.datetime "created_date"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", force: :cascade do |t|
    t.string "name"
    t.string "commentary"
    t.integer "principal"
    t.float "interest"
    t.integer "loan_term_in_months"
    t.string "payment_frequency"
    t.datetime "start_date"
    t.boolean "payments_at_end_of_period"
    t.integer "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_loans_on_entity_id"
  end

  add_foreign_key "loans", "entities"
end
