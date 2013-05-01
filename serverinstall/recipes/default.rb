#
# Cookbook Name:: serverinstall
# Recipes:: default
#
# Copyright 2013, Damien DUPORTAL
#
#


## Installing our aliases
node['serverinstall']['profiles'].each do | profileScript |
	cookbook_file "/etc/profile.d/#{profileScript}" do
		source "#{profileScript}.erb"
	end
end

## Install all C/Ruby compilation tools needed
include_recipe "build-essential"

# Install our packages
node['serverinstall']['packages'].each do | pkg |
	package "#{pkg}" do
		action :install
	end
end

## Create our standard users
node['serverinstall']['users'].each do | user |
	user "#{user}"
end

## Activate sysstats
execute "activate-systat" do
	command "sed -i 's/ENABLED=\"false\"/ENABLED=\"true\"/g' /etc/default/sysstat"
end
service "sysstat" do
	action :restart
end

## Installing Virtualbox
include_recipe "virtu-utils::virtualbox"

## And then vagrant (from opscode one)
include_recipe "vagrant"

## Now Veewee (yes we need tu build base box)
include_recipe "virtu-utils::veewee"

## Creating our system users
node.default['serverinstall']['system_users'].each do | system_user |
	user "#{system_user}" do
		action :create
		system true
	end
end

## Install Nginx for reverse proxy and creating service
include_recipe "dd-nginx"

dd_nginx_service "nginx-reverseproxy" do
	action :create
end

