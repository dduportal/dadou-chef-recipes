#
# Cookbook Name:: nginx
# Recipe:: setup
#
# Copyright 2013, Damien DUPORTAL
#
#

## We ensure that we install nginx
include_recipe "dd-nginx::default"

if node['nginx']['services'] and node['nginx']['services'].kind_of?(Hash)
	node['nginx']['services'].each do | serviceName, serviceConf |
		log "[dd-nginx] Nginx service to create : #{serviceName}"
	end
end