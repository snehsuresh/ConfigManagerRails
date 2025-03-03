class CreateAppConfigurations < ActiveRecord::Migration[7.2]
  def change
    create_table :app_configurations do |t|  # 👈 FIX THIS
      t.string :name
      t.jsonb :config_data
      t.integer :version

      t.timestamps
    end
  end
end
