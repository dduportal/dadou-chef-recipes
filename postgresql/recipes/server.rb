#
# Cookbook Name:: postgresql
# Recipe:: server
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#
# This recipe will install the pgsql servers packages provided from default.rb attributes
#

include_recipe "postgresql::default"

pgsql_major_version = node['postgresql']['version']['major']
pgsql_minor_version = node['postgresql']['version']['minor']
pgsql_short_version = pgsql_major_version + pgsql_minor_version
pgsql_version = pgsql_major_version + "." + pgsql_minor_version

# Install complementals packages
if node.attribute?('postgresql') and node['postgresql'].attribute?('server') and node['postgresql']['server'].attribute?('packages') 
	node['postgresql']['server']['packages'].each do |pg_pkg|
		package pg_pkg do
			action :install
		end
	end
end

# Install server base package
mainPkg = "postgresql#{node['postgresql']['version']['major']}#{node['postgresql']['version']['minor']}-server"
if platform?("centos", "redhat", "fedora")
	package mainPkg do
		action :install
	end

	# Install complementals packages of server pgsql (named by suffixing main pkg)
	if node.attribute?('postgresql') and node['postgresql'].attribute?('server') and node['postgresql']['server'].attribute?('packageFromMain') 
		node['postgresql']['server']['packageFromMain'].each do |pg_pkg_suffix|
			package mainPkg + "-" + pg_pkg_suffix do
				action :install
			end
		end
	end
end

pg_data_dir = "/var/lib/pgsql/#{pgsql_version}/data"

# Configure the default server
postgresql_service "postgresql-#{pgsql_version}" do
	action :create
	custom_data_dir pg_data_dir
	custom_log_file "/var/lib/pgsql/#{pgsql_version}/pgstartup.log"
	custom_pid_file "/var/run/postmaster-#{pgsql_version}.pid"
	custom_lockfile_dir "/var/lock/subsys"
	pg_version "#{pgsql_version}"
end
