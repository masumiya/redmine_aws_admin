class CreateRdsSnapshots < ActiveRecord::Migration
  def change
    create_table :rds_snapshots, id: false do |t|
      t.string :db_snapshot_identifier, null: false
      t.string :project_id
      t.string :status
      t.string :db_instance_id
      t.string :availability_zone_name
      t.string :created_at
      t.string :allocated_storage
      t.string :engine
      t.string :engine_version
      t.string :instance_create_time
      t.string :license_model
      t.string :master_username
      t.string :port
      t.string :snapshot_type
      t.string :vpc_id
    end
    add_index :rds_snapshots, :db_snapshot_identifier, unique: true
  end
end
