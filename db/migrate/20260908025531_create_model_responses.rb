class CreateModelResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :model_responses do |t|
      t.references :prompt, null: false, foreign_key: true
      t.references :model_config, null: false, foreign_key: true
      t.text :response_text
      t.integer :execution_time_ms

      t.timestamps
    end
  end
end
