#
#

action :create do
	Chef::Log.info("Creating nginx service #{new_resource.service_id}")

	serviceRootFolder = "#{new_resource.prefix_folder}/front/#{new_resource.client_id}/#{new_resource.service_id}"
	confDir = "#{serviceRootFolder}/conf"
	logsDir = "#{serviceRootFolder}/logs"
	docrootDir = "#{serviceRootFolder}/docs"
	serviceUser = new_resource.service_user
	serviceGroup = new_resource.service_group
	with_upstream = new_resource.with_upstream

	directory docrootDir do
		owner serviceUser
		group serviceGroup
		mode 0750
		action :create
		recursive true
	end

	directory logsDir do
		owner serviceUser
		group serviceGroup
		mode 0750
		action :create
		recursive true
	end

	directory "#{serviceRootFolder}/tmp" do
		owner serviceUser
		group serviceGroup
		mode 0750
		action :create
		recursive true
	end

	directory "#{confDir}/vhosts" do
		owner serviceUser
		group serviceGroup
		mode 0750
		action :create
		recursive true
	end

	directory "#{confDir}/locations" do
		owner serviceUser
		group serviceGroup
		mode 0750
		action :create
		recursive true
	end

	template "#{confDir}/nginx.conf" do
  		source "nginx.conf.erb"
		owner serviceUser
		group serviceGroup
		mode 0750
  		variables({
    		'nginx_user' => serviceUser,
    		'nginx_group' => serviceGroup,
    		'service_root_folder' => serviceRootFolder,
  		})
  	end
	
	cookbook_file "#{confDir}/mime.types" do
  		source "mime.types"
		owner serviceUser
		group serviceGroup
		mode 0750
  	end

  	if with_upstream then
  		cookbook_file "#{confDir}/upstream.conf" do
	  		source "upstream.conf"
			owner serviceUser
			group serviceGroup
			mode 0750
  		end
  	end
end