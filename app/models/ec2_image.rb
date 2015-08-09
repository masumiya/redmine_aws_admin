class Ec2Image < ActiveRecord::Base
  unloadable
  self.primary_key = :image_id
end
