#
# Cookbook Name:: postgresql
# Recipe:: client
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#
# This recipe will install the pgsql servers packages provided from default.rb attributes
#

# Install complementals packages
if node.attribute?('postgresql') and node['postgresql'].attribute?('client') and node['postgresql']['client'].attribute?('packages') 
	node['postgresql']['client']['packages'].each do |pg_pkg|
		package pg_pkg do
			action :install
		end
	end
end

# Install client base package
mainPkg = "postgresql#{node['postgresql']['version']['major']}#{node['postgresql']['version']['minor']}"
if platform?("centos", "redhat", "fedora")
	package mainPkg do
		action :install
	end

	# Install complementals packages of client pgsql (named by suffixing main pkg)
	if node.attribute?('postgresql') and node['postgresql'].attribute?('client') and node['postgresql']['client'].attribute?('packageFromMain') 
		node['postgresql']['client']['packageFromMain'].each do |pg_pkg_suffix|
			package mainPkg + "-" + pg_pkg_suffix do
				action :install
			end
		end
	end
end
