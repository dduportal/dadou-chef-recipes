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

  	#### Configuration of nginx
  	## nginx.conf
  	nginx_conf_hash = {
		'user' => "#{new_resource.service_user}",
		'worker_processes' => 1,
		'error_log' => ["#{logs_dir}/error.log","warn"],
		'pid' => "#{nginx_pid_file}",
		'events' => {
			'worker_connections' => 1024,
		},
		'http' => {
			'default_type' => 'application/octet-stream',
			'log_format' => ["main","'$remote_addr - $remote_user [$time_local] \"$request\" '","'$status $body_bytes_sent \"$http_referer\" '","'\"$http_user_agent\" \"$http_x_forwarded_for\"'"],
			'access_log' => ["#{logs_dir}/access.log","main"],
			'sendfile' => "on",
			'keepalive_timeout' => "65",
			#'include' => "#{conf_dir}/vhosts/*.conf",
			'server' => {
				'listen' => '80',
				'server_name' => 'localhost',
				'location' => ["/", {
					'root' => "#{docroot_dir}",
					'index' => ["index.html","index.htm"],
					}],
			},
		}
	}
  	dd_nginx_conf_root "#{conf_dir}/nginx.conf" do
  		nginx_conf nginx_conf_hash
  	end

  	## Adding default http vhost
  	http_vhost_conf = {
  		'listen' => '80',
  		'server_name' => 'localhost',
  		'access_log' => "#{logs_dir}/#{new_resource.service_id}-access.log",
  		'location' => {
  			'pattern' => "/",
  			'content' => {
  				'root' => "#{docroot_dir}",
  				'index' => ["index.html","index.htm"],
  			},
  		},
  	}
  	dd_nginx_conf_vhost "#{new_resource.service_id}" do
  		nginx_service "#{new_resource.service_id}"
  		nginx_vhosts_dir "#{conf_dir}/vhosts"
  		nginx_user "#{new_resource.service_user}"
  		nginx_group "#{new_resource.service_group}"
  		vhost_conf http_vhost_conf.to_hash
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
    		'nginx_user' => new_resource.service_user,
  		})
  	end

  	service "#{new_resource.service_id}" do
  		supports :restart => true, :reload => true
  		service_name "#{new_resource.service_id}"
  		action :enable
  	end

  	service "#{new_resource.service_id} start" do
  		service_name "#{new_resource.service_id}"
  		action :start
  		not_if "service #{new_resource.service_id} status"
  	end

  	service "#{new_resource.service_id} reload" do
  		service_name "#{new_resource.service_id}"
  		action :reload
  		only_if "service #{new_resource.service_id} status"
  	end

end

action :delete do

end

action :start do
	service "#{new_resource.service_id} start" do
		service_name "#{new_resource.service_id}"
		action :start
	end
end

action :stop do
	service "#{new_resource.service_id} stop" do
		service_name "#{new_resource.service_id}"
		action :stop
	end
end

action :restart do
	service "#{new_resource.service_id} restart" do
		service_name "#{new_resource.service_id}"
		action :restart
	end
end

action :reload do
	service "#{new_resource.service_id} reload" do
		service_name "#{new_resource.service_id}"
		action :reload
	end
end

action :status do
	service "#{new_resource.service_id} status" do
		service_name "#{new_resource.service_id}"
		action :status
	end
end

