#
# This recipe will insure that Nginx is installed
# Use attributes to provide the package you want.
#

include_recipe "yum"

# add the Zenoss repository
yum_repository "nginx" do
  repo_name "nginx"
  description "Nginx official repo"
  url "http://nginx.org/packages/#{node['platform']}/#{node['platform_version'].to_i}/$basearch/"
  action :add
end

# Parsing parameters
if (node['nginx']['packagename'].nil? or node['nginx']['packagename'].empty?)
	node.set['nginx']['packagename'] =  "nginx"
end

log "[Nginx] We'll use package #{node['nginx']['packagename']}"

if (node['nginx']['version'].nil? or node['nginx']['version'].empty?)
	log "[Nginx] Last known stable version will be installed"

	package node['nginx']['packagename'] do
		action :install
	end

else

	nginxVersion = "#{node['nginx']['version']}-1.el#{node['platform_version'].to_i}.ngx"

	log "[Nginx] Version #{nginxVersion} will be installed"

	package node['nginx']['packagename'] do
		action :install
		version "#{nginxVersion}"
	end
end

