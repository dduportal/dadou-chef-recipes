#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#
# This recipe will configure your system to use the official postgresql repositories
#

pgsql_major_version = node['postgresql']['version']['major']
pgsql_minor_version = node['postgresql']['version']['minor']
pgsql_short_version = pgsql_major_version + pgsql_minor_version
pgsql_version = pgsql_major_version + "." + pgsql_minor_version

log "I'm going to install postgresql server, version #{pgsql_version}.x"

if platform?("centos", "redhat", "fedora")

	# Inspirated by from http://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS20CentOS6pgdg

	repo_base_url = "http://yum.postgresql.org"
	distrib_version = node['platform_version'].split('.').first
	distrib_name = node['platform']
	arch = node['kernel']['machine']
	case distrib_name
	when "centos"
		distrib_id = "redhat/rhel"
	when "fedora"
		distrib_id = "fedora/fedora"
	when "redhat"
		distrib_id = "redhat/rhel"
	end
	
	rpm_name = "pgdg-#{distrib_name}#{pgsql_short_version}-#{pgsql_version}-#{node['postgresql']['version']['rpm']}.noarch"
	rpm_url = "#{repo_base_url}/#{pgsql_version}/#{distrib_id}-#{distrib_version}-#{arch}/#{rpm_name}.rpm"
	rpm_path = "/tmp/#{rpm_name}.rpm"

	log "As RHEL Linux, i'm going to use this rpm : #{rpm_url}"

	# Downloading the rpm
	remote_file rpm_path do
		source rpm_url
		not_if "rpm -qa | grep -q '#{rpm_name}'"
  		notifies :install, "rpm_package[pgdg]", :immediately
	end

	# Install the pgdg repo
	rpm_package "pgdg" do
		source rpm_path
		only_if {::File.exists?(rpm_path)}
		action :nothing
	end

	# Cleaning
	file rpm_path do
	  path rpm_path
	  action :delete
	end
end

include_recipe "postgresql::client"
