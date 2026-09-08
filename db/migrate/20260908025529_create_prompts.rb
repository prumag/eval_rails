class CreatePrompts < ActiveRecord::Migration[8.1]
  def change
    create_table :prompts do |t|
      t.text :body
      t.string :category
      t.text :system_instruction

      t.timestamps
    end
  end
end
