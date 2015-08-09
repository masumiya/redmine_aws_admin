module AwsAdminSettingsHelper
  def redmine_aws_admin_settings_value(key)
    defaults = Redmine::Plugin::registered_plugins[:redmine_aws_admin].settings[:default]

    value = begin
      Setting['plugin_redmine_aws_admin'][key]
    rescue
      nil
    end

    value.blank? ? defaults[key] : value
  end
end