class CreateEc2Images < ActiveRecord::Migration
  def change
    create_table :ec2_images, id: false do |t|
      t.string :image_id, null: false
      t.string :project_id
      t.string :state
      t.string :name
      t.string :architecture
      t.string :description
      t.string :hypervisor
      t.string :kernel_id
      t.string :location
      t.string :owner_alias
      t.string :platform
      t.string :state_reason
      t.string :image_type
      t.string :virtualization_type
    end
    add_index :ec2_images, :image_id, unique: true
  end
end
