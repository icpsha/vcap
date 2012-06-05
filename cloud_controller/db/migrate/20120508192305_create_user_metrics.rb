class CreateUserMetrics < ActiveRecord::Migration
  def self.up
    create_table :user_metrics do |t|
      t.integer :app_id
      t.integer :avg_latency
      t.integer :timeout

      t.timestamps
    end
  end

  def self.down
    drop_table :user_metrics
  end
end
