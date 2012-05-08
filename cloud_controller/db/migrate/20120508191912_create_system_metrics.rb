class CreateSystemMetrics < ActiveRecord::Migration
  def self.up
    create_table :system_metrics do |t|
      t.integer :app_id
      t.integer :instance_index
      t.float :cpu
      t.float :memory
      t.integer :disk

      t.timestamps
    end
  end

  def self.down
    drop_table :system_metrics
  end
end
