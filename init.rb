Redmine::Plugin.register :redmine_aws_admin do
  name 'Redmine Aws Admin plugin'
  author 'Yuichi Masumiya'
  description 'This is a AWS Administration plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'masumiya@lepra.jp'

  requires_redmine :version_or_higher => '2.4.0'

  settings :default => {
    :aws_accesskey_id => "",
    :aws_accesskey => "",
  }, :partial => 'settings/aws_admin_settings'

  project_module :aws_admin do
    permission :view_instances, :instances => [:index, :show, :reload], :require => :member
    #permission :manage_instances, :instances => [:start, :stop, :reboot], :require => :admin
  end

  menu :project_menu,
    :instances,
    {:controller => 'instances', :action => 'index'},
    :caption => 'AWS',
    :param => :project_id
end
