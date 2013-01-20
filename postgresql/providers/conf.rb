#
# Cookbook Name:: postgresql
# Provider:: conf
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#
# This provider implements the postgresql_conf resource
#
# => Inspired by the chef comunity postgresql cookbook : https://github.com/opscode-cookbooks/postgresql
#

action :apply do

	service_name = new_resource.service_name
	pg_data_dir = new_resource.service_dir.chomp('/')

	if new_resource.config and new_resource.config.kind_of?(Hash) and new_resource.config.length > 0 then
		template pg_data_dir + "/postgresql.conf" do
		  source "postgresql.conf.erb"
		  owner "postgres"
		  group "postgres"
		  variables(new_resource.config)
		  notifies :restart, "postgresql_service[#{service_name}]", :immediately
		end
	else
		log "No "
	end

	if new_resource.hba_config and new_resource.hba_config.kind_of?(Array) and new_resource.hba_config.length > 0 then
		template pg_data_dir + "/pg_hba.conf" do
		  source "pg_hba.conf.erb"
		  owner "postgres"
		  group "postgres"
		  variables(
		  	:pg_hba => new_resource.hba_config
		  )
		  notifies :reload, "postgresql_service[#{service_name}]", :immediately
		end
	end
end