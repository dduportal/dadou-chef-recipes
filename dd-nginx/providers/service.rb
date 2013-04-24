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

  	## Add config here !

	template "/etc/init.d/#{new_resource.service_id}-nginx" do
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
end