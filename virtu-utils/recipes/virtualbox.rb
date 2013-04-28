#
# Cookbook Name:: virtu-utils
# Recipe:: virtualbox
#
# Copyright 2013, Damien DUPORTAL
#
#

include_recipe "build-essential"
include_recipe "apt" if [ 'debian', 'ubuntu' ].member? node[:platform]
include_recipe "yum" if [ 'centos', 'rhel' ].member? node[:platform]

case node['platform']
when "ubuntu", "debian"

	# Adding apt repository for Oracle VirtualBox
	apt_repository "virtualbox" do
	  uri "http://download.virtualbox.org/virtualbox/debian"
	  distribution "#{node['lsb']['codename'] }"
	  components ["contrib","non-free"]
	  key "http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc"
	end

	package "virtualbox-#{node['virtualbox']['version']}" do
		action :install
	end

end