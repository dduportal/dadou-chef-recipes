#
# Create /srv/:client_id/:server_id

actions :create, :delete

attribute :prefix_folder, :kind_of => String, :default => "/srv"
attribute :client_id, :kind_of => String, :required => true
attribute :service_id, :kind_of => String, :name_attribute => true
attribute :nginx_bin, :kind_of => String, :default => "/usr/sbin/nginx"
attribute :with_upstream,  :default => false
attribute :service_user, :kind_of => String, :regex => Chef::Config[:user_valid_regex], :default => "www" 
attribute :service_group, :kind_of => String, :regex => Chef::Config[:group_valid_regex], :default => "www"
