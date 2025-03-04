class AddDefaultVersionToAppConfigurations < ActiveRecord::Migration[7.0]
  def change
    change_column_default :app_configurations, :version, from: nil, to: 1
  end
end
