#
#

action :configure do
	serviceId = new_resource.service_id
	clientId = new_resource.client_id
	cookbook_for_tpl = new_resource.cookbook
	serviceUser = node['nginx']['root_conf']['user'].kind_of?(String) ? node['nginx']['root_conf']['user'] : node['nginx']['root_conf']['user'][0]
	# If user is a string, we have same users and group. Elsewere, we have to fetch group
	serviceGroup = node['nginx']['root_conf']['user'].kind_of?(String) ? node['nginx']['root_conf']['user'] : node['nginx']['root_conf']['user'][1]

	nginxRootConf = "#{new_resource.prefix_folder}/#{clientId}/#{serviceId}/conf"

	Chef::Log.info("Generating nginx.conf file in #{nginxRootConf}")

	# Setting nginx root
	template "#{nginxRootConf}/nginx.conf" do
  		source "nginx.conf.erb"
  		cookbook cookbook_for_tpl
		owner serviceUser
		group serviceGroup
		mode 0644
  		variables({
  			'root_conf' => node['nginx']['root_conf'].to_hash
  		})
  	end
end
