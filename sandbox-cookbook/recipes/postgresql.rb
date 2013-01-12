#
# Cookbook Name:: dadou-chef-recipes
# Recipe:: postgresql
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#

pgsql_major_version = node['dadou']['postgresql']['version']['major']
pgsql_minor_version = node['dadou']['postgresql']['version']['minor']
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
		distrib_num = "6"
	when "fedora"
		distrib_id = "fedora/fedora"
		distrib_num = "5"
	when "redhat"
		distrib_id = "redhat/rhel"
		distrib_num = "7"
	end
	
	rpm_name = "pgdg-#{distrib_name}#{pgsql_short_version}-#{pgsql_version}-#{distrib_num}.noarch"
	rpm_url = "#{repo_base_url}/#{pgsql_version}/#{distrib_id}-#{distrib_version}-#{arch}/#{rpm_name}.rpm"

	log "As RHEL Linux, i'm going to use this rpm : #{rpm_url}"

	# Downloading the rpm
	remote_file "/tmp/#{rpm_name}.rpm" do
		source rpm_url
		action :create
	end

	# Install the pgdg repo
	package "pgdg" do
		action :install
		source "/tmp/#{rpm_name}.rpm"
  		provider Chef::Provider::Package::Rpm
	end

	# Install postgresql package
	#yum_package "postgresql#{pgsql_short_version}-server" do
	#	flush_cache [ :before ]
	#end
end
	
# Configure our pgsql
node.set['postgresql'] = {
	'version' => pgsql_version,
	'dir' => node['dadou']['postgresql']['dir'],
	'password' => node['dadou']['postgresql']['password'],
	'server' => {
		'packages' => ["postgresql#{pgsql_short_version}-server"],
		'service_name' => "postgresql-#{pgsql_version}"
	},
	'client' => {
		'packages' => ["postgresql#{pgsql_short_version}"]
	}
}

# Go for postgresql server
include_recipe "postgresql::server"




