#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, Damien DUPORTAL
#
#

## Adding package manager'OS specific repository
case node['platform']
when "ubuntu","debian"
	include_recipe "apt"

	apt_repository "nginx" do
	  uri "http://nginx.org/packages/debian/"
	  distribution "#{node['lsb']['codename'] }"
	  components ["nginx"]
	  key "http://nginx.org/keys/nginx_signing.key"
	  deb_src true
	end
when "centos","rhel","fedora"
	include_recipe "yum"

	yum_repository "nginx" do
	  repo_name "nginx"
	  description "Nginx official repo"
	  url "http://nginx.org/packages/#{node['platform']}/#{node['platform_version'].to_i}/$basearch/"
	  action :add
	end
end

# Cas of missing attributes
if node['nginx']['packagename'] == nil or node['nginx']['packagename'].empty?
	node.set['nginx']['packagename'] = "nginx"
end

# Installing Nginx package
if node['nginx']['packagename'] == nil or node['nginx']['packagename'].empty?
	package node['nginx']['packagename'] do
		action :install
		version node['nginx']['version']
	end
else
	package node['nginx']['packagename'] do
		action :install
	end
end

## We have to stop and disable the default nginx service (yes we don't use default :-D)
service "nginx" do
	action :stop,:disable
end
