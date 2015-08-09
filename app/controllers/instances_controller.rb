require 'aws-sdk'
class InstancesController < ApplicationController
  unloadable

  AWS_EC2 = 1
  AWS_RDS = 2
  AWS_EC2_IMAGE = 3
  AWS_RDS_SNAPSHOT = 4

  helper :aws_admin_settings
  include AwsAdminSettingsHelper

  before_filter :find_project, :authorize, :connect_aws

  rescue_from ActionView::MissingTemplate, :with => :render_404
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def index
    logger.info "Start INDEX"
    update_list
    list_ec2
    list_rds
    list_ec2_image
    list_rds_snapshot
  end

  def show
    logger.info "Start SHOW [#{params[:id]}]"
    @view_type = params[:id].to_i
    case @view_type
    when AWS_EC2
      logger.info "SHOW AWS EC2"
      begin
        save_ec2 unless reload_lock?
      rescue => e
        error_log(e)
      ensure
        unlock
      end
      list_ec2
    when AWS_RDS
      logger.info "SHOW AWS RDS"
      begin
        save_rds unless reload_lock?
      rescue => e
        error_log(e)
      ensure
        unlock
      end
      list_rds
    when AWS_EC2_IMAGE
      logger.info "SHOW AWS EC2 IMAGE"
      begin
        save_ec2_image unless reload_lock?
      rescue => e
        error_log(e)
      ensure
        unlock
      end
      list_ec2_image
    when AWS_RDS_SNAPSHOT
      logger.info "SHOW AWS RDS SNAPSHOT"
      begin
        save_rds_snapshot unless reload_lock?
      rescue => e
        error_log(e)
      ensure
        unlock
      end
      list_rds_snapshot
    end
  end

  def reload
  end

  def start
  end

  def stop
  end

  def reboot
  end

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end

    render :template => "errors/error_404", :status => 404, :layout => 'application', :content_type => 'text/html'
  end

  def render_500(exception = nil)
    if exception
      logger.error "Rendering 500 with exception: #{exception.message}"
    end

    render :template => "errors/error_500", :status => 500, :layout => 'application'
  end

#######
private
#######
  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_instance
    @instance = Instance.find_by_id(params[:id])
    render_404 unless @instance
  end

  def list_ec2
    @ec2_instances = Ec2Instance.where(["project_id = '?'", @project])
    @total_ec2_instances = @ec2_instances.count
  end

  def list_rds
    @rds_instances = RdsInstance.where(["project_id = '?'", @project])
    @total_rds_instances = @rds_instances.count
  end

  def list_ec2_image
    @ec2_images = Ec2Image.where(["project_id = '?'", @project])
    @total_ec2_images = @ec2_images.count
  end

  def list_rds_snapshot
    @rds_snapshots = RdsSnapshot.where(["project_id = '?'", @project])
    @total_rds_snapshots = @rds_snapshots.count
  end

  def save_ec2
    logger.info "SAVE AWS EC2"
    Ec2Instance.destroy_all
    AWS.ec2.instances.each do |ec2_node|
      ec2_instance = Ec2Instance.new(params[:instance])
      ec2_instance.project_id = @project
      ec2_instance.id = ec2_node.id
      ec2_instance.status = ec2_node.status
      ec2_instance.platform = ec2_node.platform ? "Windows" : "Not Windows"
      ec2_instance.ip_address = ec2_node.ip_address
      ec2_instance.dns_name = ec2_node.dns_name
      ec2_instance.private_ip_address = ec2_node.private_ip_address
      ec2_instance.private_dns_name = ec2_node.private_dns_name
      ec2_instance.availability_zone = ec2_node.availability_zone
      ec2_instance.ami_launch_index = ec2_node.ami_launch_index
      ec2_instance.architecture = ec2_node.architecture
      ec2_instance.elastic_ip = ec2_node.elastic_ip.to_s
      ec2_instance.hypervisor = ec2_node.hypervisor
      ec2_instance.iam_instance_profile_arn = ec2_node.iam_instance_profile_arn
      ec2_instance.iam_instance_profile_id = ec2_node.iam_instance_profile_id
      ec2_instance.image_id = ec2_node.image_id
      ec2_instance.launch_time = ec2_node.launch_time
      ec2_instance.subnet_id = ec2_node.subnet_id
      ec2_instance.virtualization_type = ec2_node.virtualization_type
      ec2_instance.vpc_id = ec2_node.vpc_id
      ec2_instance.save
    end
  end

  def save_rds
    logger.info "SAVE AWS RDS"
    RdsInstance.destroy_all
    AWS.rds.instances.each do |rds_node|
      rds_instance = RdsInstance.new(params[:instance])
      rds_instance.db_instance_identifier = rds_node.db_instance_identifier
      rds_instance.project_id = @project
      rds_instance.db_instance_status = rds_node.db_instance_status
      rds_instance.db_name = rds_node.db_name
      rds_instance.endpoint_address = rds_node.endpoint_address
      rds_instance.allocated_storage = rds_node.allocated_storage
      rds_instance.auto_minor_version_upgrade = rds_node.auto_minor_version_upgrade
      rds_instance.availability_zone_name = rds_node.availability_zone_name
      rds_instance.backup_retention_period = rds_node.backup_retention_period
      rds_instance.character_set_name = rds_node.character_set_name
      rds_instance.creation_date_time = rds_node.creation_date_time
      rds_instance.db_instance_class = rds_node.db_instance_class
      rds_instance.endpoint_port = rds_node.endpoint_port
      rds_instance.engine = rds_node.engine
      rds_instance.engine_version = rds_node.engine_version
      rds_instance.iops = rds_node.iops
      rds_instance.latest_restorable_time = rds_node.latest_restorable_time
      rds_instance.license_model = rds_node.license_model
      rds_instance.master_username = rds_node.master_username
      rds_instance.multi_az = rds_node.multi_az
      rds_instance.preferred_backup_window = rds_node.preferred_backup_window
      rds_instance.preferred_maintenance_window = rds_node.preferred_maintenance_window
      rds_instance.read_replica_db_instance_identifiers = rds_node.read_replica_db_instance_identifiers.join(', ')
      rds_instance.read_replica_source_db_instance_identifier = rds_node.read_replica_source_db_instance_identifier
      rds_instance.vpc_id = rds_node.vpc_id
      rds_instance.save
    end
  end

  def save_ec2_image
    logger.info "SAVE AWS EC2 IMAGE"
    Ec2Image.destroy_all
    AWS.ec2.images.with_owner(:self).each do |image|
      ec2_image = Ec2Image.new(params[:instance])
      ec2_image.project_id = @project
      ec2_image.image_id = image.image_id
      ec2_image.state = image.state
      ec2_image.name = image.name
      ec2_image.architecture = image.architecture
      ec2_image.description = image.description
      ec2_image.hypervisor = image.hypervisor
      ec2_image.kernel_id = image.kernel_id
      ec2_image.location = image.location
      ec2_image.owner_alias = image.owner_alias
      ec2_image.platform = image.platform ? "Windws" : "Not Windows"
      ec2_image.state_reason = image.state_reason
      ec2_image.image_type = image.type.to_s
      ec2_image.virtualization_type = image.virtualization_type
      ec2_image.save
    end
  end

  def save_rds_snapshot
    logger.info "SAVE AWS RDS SNAPSHOT"
    RdsSnapshot.destroy_all
    AWS.rds.snapshots.each do |ss_node|
      rds_snapshot = RdsSnapshot.new(params[:instance])
      rds_snapshot.project_id = @project
      rds_snapshot.db_snapshot_identifier = ss_node.db_snapshot_identifier
      rds_snapshot.status = ss_node.status
      rds_snapshot.db_instance_id = ss_node.db_instance_id
      rds_snapshot.availability_zone_name = ss_node.availability_zone_name
      rds_snapshot.created_at = ss_node.created_at
      rds_snapshot.allocated_storage = ss_node.allocated_storage
      rds_snapshot.engine = ss_node.engine
      rds_snapshot.engine_version = ss_node.engine_version
      rds_snapshot.instance_create_time = ss_node.instance_create_time
      rds_snapshot.license_model = ss_node.license_model
      rds_snapshot.master_username = ss_node.master_username
      rds_snapshot.port = ss_node.port
      rds_snapshot.snapshot_type = ss_node.snapshot_type
      rds_snapshot.vpc_id = ss_node.vpc_id
      rds_snapshot.save
    end
  end

  def save_items(type_id)
    case type_id
    when AWS_EC2
      return save_ec2
    when AWS_RDS
      return save_rds
    when AWS_EC2_IMAGE
      return save_ec2_image
    when AWS_RDS_SNAPSHOT
      return save_rds_snapshot
    end
  end

  def connect_aws
    aws_accesskey_id = redmine_aws_admin_settings_value(:aws_accesskey_id).to_s
    aws_accesskey = redmine_aws_admin_settings_value(:aws_accesskey).to_s
    aws_region = redmine_aws_admin_settings_value(:aws_region).to_s
    AWS.config(access_key_id: aws_accesskey_id, secret_access_key: aws_accesskey, region: aws_region)
  end

  def update_list
    begin
      return if reload_lock?
      save_items(AWS_EC2)
      save_items(AWS_RDS)
      save_items(AWS_EC2_IMAGE)
      save_items(AWS_RDS_SNAPSHOT)
    rescue => e
      error_log(e)
      return
    ensure
      unlock
    end
  end

  def reload_lock?
    return true if File.exist?("reload-*.lock")
    @tf = Tempfile.new(['reload-', '.lock'], './tmp')
    logger.info "LOCKED!"
    return false
  end

  def unlock
    return if @tf.blank?
    @tf.close
    @tf.unlink
    logger.info "UNLOCKED!"
  end

  def error_log(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
  end
end
