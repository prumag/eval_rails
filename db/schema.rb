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

ActiveRecord::Schema[8.1].define(version: 2026_09_08_025534) do
  create_table "evaluations", force: :cascade do |t|
    t.integer "accuracy_score"
    t.integer "clarity_score"
    t.datetime "created_at", null: false
    t.string "evaluator_name"
    t.text "feedback_notes"
    t.integer "instruction_score"
    t.boolean "is_tie", default: false
    t.integer "loser_response_id"
    t.integer "prompt_id", null: false
    t.datetime "updated_at", null: false
    t.integer "winner_response_id"
    t.index ["loser_response_id"], name: "index_evaluations_on_loser_response_id"
    t.index ["prompt_id"], name: "index_evaluations_on_prompt_id"
    t.index ["winner_response_id"], name: "index_evaluations_on_winner_response_id"
  end

  create_table "model_configs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "model_identifier"
    t.string "name"
    t.string "provider"
    t.float "temperature"
    t.datetime "updated_at", null: false
  end

  create_table "model_responses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "execution_time_ms"
    t.integer "model_config_id", null: false
    t.integer "prompt_id", null: false
    t.text "response_text"
    t.datetime "updated_at", null: false
    t.index ["model_config_id"], name: "index_model_responses_on_model_config_id"
    t.index ["prompt_id"], name: "index_model_responses_on_prompt_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.text "body"
    t.string "category"
    t.datetime "created_at", null: false
    t.text "system_instruction"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "evaluations", "model_responses", column: "loser_response_id"
  add_foreign_key "evaluations", "model_responses", column: "winner_response_id"
  add_foreign_key "evaluations", "prompts"
  add_foreign_key "model_responses", "model_configs"
  add_foreign_key "model_responses", "prompts"
end
