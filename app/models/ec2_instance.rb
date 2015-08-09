class Ec2Instance < ActiveRecord::Base
  unloadable
  self.primary_key = :id
end
