class RdsInstance < ActiveRecord::Base
  unloadable
  self.primary_key = :db_instance_identifier
  has_many :rds_snapshots, foreign_key: :db_instance_id
end
