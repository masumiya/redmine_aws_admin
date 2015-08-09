class CreateEc2Instances < ActiveRecord::Migration
  def change
    create_table :ec2_instances, id: false do |t|
      t.string :id, null: false
      t.string :project_id
      t.string :status
      t.string :platform
      t.string :ip_address
      t.string :dns_name
      t.string :private_ip_address
      t.string :private_dns_name
      t.string :availability_zone
      t.integer :ami_launch_index
      t.string :architecture
      t.string :elastic_ip
      t.string :hypervisor
      t.string :iam_instance_profile_arn
      t.string :iam_instance_profile_id
      t.string :image_id
      t.string :launch_time
      t.string :subnet_id
      t.string :virtualization_type
      t.string :vpc_id
    end
    add_index :ec2_instances, :id, unique: true
  end
end
