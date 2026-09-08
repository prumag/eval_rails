class CreateModelConfigs < ActiveRecord::Migration[8.1]
  def change
    create_table :model_configs do |t|
      t.string :name
      t.string :provider
      t.string :model_identifier
      t.float :temperature

      t.timestamps
    end
  end
end
