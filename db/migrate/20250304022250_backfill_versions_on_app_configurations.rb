class BackfillVersionsOnAppConfigurations < ActiveRecord::Migration[7.2]
  def up
    AppConfiguration.where(version: nil).update_all(version: 1)
  end

  def down
    # No-op — we don’t "undo" data backfills
  end
end

