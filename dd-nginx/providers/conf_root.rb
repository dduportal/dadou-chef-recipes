#
# Cookbook Name:: nginx
# Provider:: conf_root
#
# Copyright 2013, Damien DUPORTAL
#
#
action :configure do

	if new_resource.nginx_conf['user'] and ! new_resource.nginx_conf['user'].empty?
		nginx_user = "www"
	end
	if new_resource.nginx_conf['group'] and ! new_resource.nginx_conf['group'].empty?
		nginx_group = "www"
	end

	Chef::Log.info("Generating nginx.conf file in #{new_resource.nginx_conf_file}")

	# Setting nginx root
	template "#{new_resource.nginx_conf_file}" do
  		source "nginx.conf.erb"
  		cookbook new_resource.cookbook
		owner nginx_user
		group nginx_group
		mode 0644
  		variables({
  			'nginx_conf' => new_resource.nginx_conf.to_hash
  		})
  	end
end
