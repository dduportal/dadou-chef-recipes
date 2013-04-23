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

## Activate sysstats
execute "activate-systat" do
	command "sed -i 's/ENABLED=\"false\"/ENABLED=\"true\"/g' /etc/default/sysstat"
end
service "sysstat" do
	action :restart
end

## Installing Virtualbox
include_recipe "virtualbox"

