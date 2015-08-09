class CreateRdsInstances < ActiveRecord::Migration
  def change
    create_table :rds_instances, id: false do |t|
      t.string :db_instance_identifier, null: false
      t.string :project_id
      t.string :db_instance_status
      t.string :db_name
      t.string :endpoint_address
      t.string :allocated_storage
      t.string :auto_minor_version_upgrade
      t.string :availability_zone_name
      t.string :backup_retention_period
      t.string :character_set_name
      t.string :creation_date_time
      t.string :db_instance_class
      t.string :endpoint_port
      t.string :engine
      t.string :engine_version
      t.string :iops
      t.string :latest_restorable_time
      t.string :license_model
      t.string :master_username
      t.string :multi_az
      t.string :preferred_backup_window
      t.string :preferred_maintenance_window
      t.string :read_replica_db_instance_identifiers
      t.string :read_replica_source_db_instance_identifier
      t.string :vpc_id
    end
    add_index :rds_instances, :db_instance_identifier, unique: true
  end
end
