#
# Cookbook Name:: virtu-utils
# Recipe:: veewee
#
# Copyright 2013, Damien DUPORTAL
#
#

## Installing all necessary for building
include_recipe "build-essential"

node['veewee']['dependencies'].each do | pkg |
	package "#{pkg}" do
		action :install
	end
end

include_recipe "rvm::ruby_192"

## Getting source code
directory "#{node['veewee']['installDir']}" do
	recursive true
	action :create
end

git "veewee" do
	repository "#{node['veewee']['gitUrl']}"
	destination "#{node['veewee']['installDir']}"
end