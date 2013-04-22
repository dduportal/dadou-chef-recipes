#
# Cookbook Name:: jdk
# Recipe:: default
#
# Copyright 2013 Damien DUPORTAL <damien.duportal@gmail.com>
#

include_recipe "yum::epel"

# Parsing parameters
if (node['jdk']['packagename'].nil? or node['jdk']['packagename'].empty?)
	node.set['jdk']['packagename'] =  "java-1.#{node['jdk']['majorversion']}.0-openjdk"
end

log "[JDK] We'll install #{node['jdk']['packagename']}"

if ((node['jdk']['home']).nil? or node['jdk']['home'].empty?)
	node.set['jdk']['home'] = "/usr/lib/jvm/jre-openjdk"
end

log "[JDK] Java home is #{node['jdk']['home']}"

# Install jdk package from default parameters
package node['jdk']['packagename'] do
	action :install
end

# Write env profile for all users of VM
template '/etc/profile.d/env-java.sh' do
	source 'env-java.sh.erb'
	owner 'root'
	group 'root'
	mode 0644
	cookbook "dd-jdk" 
	variables(
		:jdk_home => node['jdk']['home']
	)
end
