#
# Cookbook Name:: postgresql
# Recipe:: postgis
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#
# This recipe will install the pgsql servers packages provided from default.rb attributes
#

include_recipe "yum::epel"

# Install complementals packages
if node.attribute?('postgresql') and node['postgresql'].attribute?('postgis') and node['postgresql']['postgis'].attribute?('packages') 
	node['postgresql']['postgis']['packages'].each do |pg_pkg|
		package pg_pkg do
			action :install
		end
	end
end

# Install postgis base package
mainPkg = "postgis#{node['postgresql']['postgis']['version']}_#{node['postgresql']['version']['major']}#{node['postgresql']['version']['minor']}"
if platform?("centos", "redhat", "fedora")
	package mainPkg do
		action :install
	end

	# Install complementals packages of server pgsql (named by suffixing main pkg)
	if node.attribute?('postgresql') and node['postgresql'].attribute?('postgis') and node['postgresql']['postgis'].attribute?('packageFromMain') 
		node['postgresql']['postgis']['packageFromMain'].each do |pg_pkg_suffix|
			package mainPkg + "-" + pg_pkg_suffix do
				action :install
			end
		end
	end
end
