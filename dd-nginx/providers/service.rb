#
#

action :create do
	Chef::Log.info("Creating nginx service #{new_resource.service_id}")

	service_id = new_resource.service_id
	client_id = new_resource.client_id
	serviceUser = new_resource.service_user
	serviceGroup = new_resource.service_group
	with_upstream = new_resource.with_upstream
	is_atos = new_resource.is_atos
	cookbook_for_tpl = new_resource.cookbook

	serviceRootFolder = "#{new_resource.prefix_folder}/#{client_id}/#{service_id}"
	confDir = "#{serviceRootFolder}/conf"
	logsDir = "#{serviceRootFolder}/logs"
	docrootDir = "#{serviceRootFolder}/docs"
	tmpDir = "#{serviceRootFolder}/tmp"
	if is_atos then
  		nginx_bin = "/usr/#{node['nginx']['packagename']}-#{node['nginx']['version']}/sbin/nginx"
  		nginx_pid_file = "#{logsDir}/nginx.pid"
  	else
  		nginx_bin = new_resource.nginx_bin
  		nginx_pid_file = "#{tmpDir}/nginx.pid"
  	end
	
	directory serviceRootFolder do
		owner serviceUser
		group serviceGroup
		mode 0755
		action :create
		recursive true
	end

	directory confDir do
		owner serviceUser
		group serviceGroup
		mode 0755
		action :create
		recursive true
	end

	directory docrootDir do
		owner serviceUser
		group serviceGroup
		mode 0755
		action :create
		recursive true
	end

	directory logsDir do
		owner serviceUser
		group serviceGroup
		mode 0755
		action :create
		recursive true
	end

	directory tmpDir do
		owner serviceUser
		group serviceGroup
		mode 0755
		action :create
		recursive true
	end

	directory "#{confDir}/vhosts" do
		owner serviceUser
		group serviceGroup
		mode 0755
		action :create
		recursive true
	end

	directory "#{confDir}/locations" do
		owner serviceUser
		group serviceGroup
		mode 0755
		action :create
		recursive true
	end

  	template "#{docrootDir}/index.html" do
  		source "index.html.erb"
  		cookbook cookbook_for_tpl
		owner serviceUser
		group serviceGroup
		mode 0644
  		variables({
	    	'service_name' => service_id,
  		})
  	end
	template "#{confDir}/vhosts/#{service_id}.conf" do 
  		source "default-vhost.conf.erb"
  		cookbook cookbook_for_tpl
  		owner serviceUser
		group serviceGroup
		mode 0644 
		variables({
    		'service_root_folder' => serviceRootFolder,
    		'docroot' => docrootDir,
  		})
  	end
	cookbook_file "#{confDir}/mime.types" do
  		source "mime.types"
  		cookbook cookbook_for_tpl
		owner serviceUser
		group serviceGroup
		mode 0644
  	end

  	if with_upstream then
  		cookbook_file "#{confDir}/upstream.conf" do
	  		source "upstream.conf"
	  		cookbook cookbook_for_tpl
			owner serviceUser
			group serviceGroup
			mode 0644
  		end
  	end

  	# Nginx root configuration (http directives)
  	node.set['nginx']['root_conf']['http']['includes'] = ['mime.types','vhosts/*.conf']
 	nginx_root_conf service_id do
		client_id client_id
	end

  	if is_atos then
  		# with atos service tools, we need nginx.properties file
  		template "#{confDir}/nginx.properties" do
	  		source "nginx.properties.erb"
	  		cookbook cookbook_for_tpl
			owner serviceUser
			group serviceGroup
			mode 0644
	  		variables({
	    		'nginx_bin' => nginx_bin,
	  		})
	  	end

	  	## Creating service tools dirs and conf files
	  	directory "/etc/servicetools/services/#{client_id}" do
			owner "root"
			group "root"
			mode 0755
			action :create
			recursive true
		end
		directory "/etc/servicetools/dispatchers/#{client_id}" do
			owner "root"
			group "root"
			mode 0755
			action :create
			recursive true
		end
		template "/etc/servicetools/services/#{client_id}/#{service_id}" do 
			source "servicetools-nginx-service-conf.erb"
			cookbook cookbook_for_tpl
			owner "root"
			group "root"
			mode 0644
	  		variables({
	    		'service_root' => serviceRootFolder,
	  		})
		end
		execute "servicetools-dispatcher" do
		  command "echo $(hostname) > /etc/servicetools/dispatchers/#{client_id}/front"
		  action :run
		end

  	else
  		template "/etc/init.d/#{new_resource.service_id}-nginx" do
	  		source "init-script-nginx.erb"
	  		cookbook cookbook_for_tpl
			owner 'root'
			group 'root'
			mode 0755
	  		variables({
	    		'nginx_user' => serviceUser,
	    		'nginx_group' => serviceGroup,
	    		'service_root_folder' => serviceRootFolder,
	    		'nginx_conf_dir' => confDir,
	    		'nginx_tmp_dir' => tmpDir,
	    		'nginx_bin' => nginx_bin,
	    		'service_name' => service_id,
	  		})
	  	end
  	end
end