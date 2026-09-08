class CreateEvaluations < ActiveRecord::Migration[8.1]
  def change
    create_table :evaluations do |t|
      t.references :prompt, null: false, foreign_key: true
      t.references :winner_response, null: true, foreign_key: { to_table: :model_responses }
      t.references :loser_response, null: true, foreign_key: { to_table: :model_responses }
      t.boolean :is_tie, default: false
      t.integer :accuracy_score
      t.integer :clarity_score
      t.integer :instruction_score
      t.text :feedback_notes
      t.string :evaluator_name

      t.timestamps
    end
  end
end
