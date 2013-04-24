#
# Cookbook Name:: nginx
# Provider:: service
#
# Copyright 2013, Damien DUPORTAL
#
#

action :create do
	Chef::Log.info("Creating nginx service #{new_resource.service_id}")

	service_root_folder = "#{new_resource.nginx_root_dir}/#{new_resource.service_id}"
	conf_dir = "#{service_root_folder}/conf"
	logs_dir = "#{service_root_folder}/logs"
	docroot_dir = "#{service_root_folder}/docs"
	tmp_dir = "#{service_root_folder}/tmp"
	nginx_pid_file = "#{tmp_dir}/nginx.pid"
	
	directory service_root_folder do
		owner new_resource.service_user
		group new_resource.service_group
		mode 0755
		action :create
		recursive true
	end

	directory conf_dir do
		owner new_resource.service_user
		group new_resource.service_group
		mode 0755
		action :create
		recursive true
	end

	directory docroot_dir do
		owner new_resource.service_user
		group new_resource.service_group
		mode 0755
		action :create
		recursive true
	end

	directory logs_dir do
		owner new_resource.service_user
		group new_resource.service_group
		mode 0755
		action :create
		recursive true
	end

	directory tmp_dir do
		owner new_resource.service_user
		group new_resource.service_group
		mode 0755
		action :create
		recursive true
	end

  	template "#{docroot_dir}/index.html" do
  		source "index.html.erb"
  		cookbook new_resource.cookbook
		owner new_resource.service_user
		group new_resource.service_group
		mode 0644
  		variables({
	    	'service_name' => new_resource.service_id,
  		})
  	end

  	## Configuration of default nginx
  	nginx_conf_hash = {
		'user' => 'www',
		'worker_processes' => 1,
		'error_log' => ["#{logs_dir}/error.log","warn"],
	}
  	dd_nginx_conf_root "#{conf_dir}/nginx.conf" do
  		nginx_conf nginx_conf_hash
  	end

	template "/etc/init.d/#{new_resource.service_id}" do
  		source "init-script-nginx.erb"
  		cookbook new_resource.cookbook
		owner 'root'
		group 'root'
		mode 0755
  		variables({
    		'nginx_root_dir' => service_root_folder,
    		'nginx_conf_dir' => conf_dir,
    		'nginx_tmp_dir' => tmp_dir,
    		'nginx_bin' => new_resource.nginx_bin,
    		'service_name' => new_resource.service_id,
  		})
  	end

  	dd_nginx_service "#{new_resource.service_id}" do
  		action :start
  	end
end

action :delete do

end

action :start do
	service "#{new_resource.service_id}" do
		action :start
	end
end

action :stop do
	service "#{new_resource.service_id}" do
		action :stop
	end
end

action :restart do
	service "#{new_resource.service_id}" do
		action :restart
	end
end

action :reload do
	service "#{new_resource.service_id}" do
		action :reload
	end
end

action :status do
	service "#{new_resource.service_id}" do
		action :status
	end
end

