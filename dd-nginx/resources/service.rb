#
# Create /srv/:client_id/:server_id

actions :create, :delete

default_action :create

attribute :nginx_root_dir, :kind_of => String, :default => "/srv/webs"
attribute :service_id, :kind_of => String, :name_attribute => true
attribute :nginx_bin, :kind_of => String, :default => "/usr/sbin/nginx"
attribute :service_user, :kind_of => String, :regex => Chef::Config[:user_valid_regex], :default => "www" 
attribute :service_group, :kind_of => String, :regex => Chef::Config[:group_valid_regex], :default => "www"
attribute :cookbook, :kind_of => String, :default => 'dd-nginx' # Use this to overwrite cookbook's templates provider
