class RdsSnapshot < ActiveRecord::Base
  unloadable
  self.primary_key = :db_snapshot_identifier
  belongs_to :rds_instances, foreign_key: :db_instance_id
end
