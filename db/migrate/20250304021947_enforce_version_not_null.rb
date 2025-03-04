class EnforceNonNullVersionOnAppConfigurations < ActiveRecord::Migration[7.2]
  def change
    change_column_default :app_configurations, :version, from: nil, to: 1
    change_column_null :app_configurations, :version, false, 1
  end
end
