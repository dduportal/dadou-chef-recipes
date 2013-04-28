#
# Cookbook Name:: virtu-utils
# Recipe:: veewee
#
# Copyright 2013, Damien DUPORTAL
#
#

include_recipe "build-essential"

node['veewee']['dependencies'].each do | pkg |
	package "#{pkg}" do
		action :install
	end
end
