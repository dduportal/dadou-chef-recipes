#
# Cookbook Name:: nginx
# Provider:: service
#
# Copyright 2013, Damien DUPORTAL
#
#

action :add do
	Chef::Log.info("Adding a new vhost : #{new_resource.nginx_vhosts_dir}/#{new_resource.vhost_name}")

	render_vhost()
end

action :update do
	Chef::Log.info("Updating vhost : #{new_resource.nginx_vhosts_dir}/#{new_resource.vhost_name}")
	render_vhost()
end

action :remove do
	Chef::Log.info("Removing vhost : #{new_resource.nginx_vhosts_dir}/#{new_resource.vhost_name}")

	file get_vhost_full_path() do
		action :delete
	end

	service "#{new_resource.nginx_service}" do
  		action :reload
  	end

end

def render_vhost()

	if new_resource.nginx_group == nil or new_resource.nginx_group.empty ? then
		new_resource.nginx_group = "www"
	end

	directory "#{new_resource.nginx_vhosts_dir}" do
		recursive true
		action :create
		user new_resource.nginx_user
		group new_resource.nginx_group
	end

	# Setting nginx root
	template get_vhost_full_path() do
  		source "vhost.conf.erb"
  		cookbook new_resource.cookbook
  		user new_resource.nginx_user
  		group new_resource.nginx_group
		mode 0644
  		variables({
  			'nvhost_conf' => new_resource.vhost_conf.to_hash
  		})
  	end

  	service "#{new_resource.nginx_service}" do
  		action :reload
  	end
end

def get_vhost_full_path()
	return "#{new_resource.nginx_vhosts_dir}/#{new_resource.vhost_name}.conf"
end