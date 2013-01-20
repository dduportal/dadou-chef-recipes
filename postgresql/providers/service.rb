#
# Cookbook Name:: postgresql
# Provider:: service
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#
# This provider implements the postgresql_service resource
#
# => Inspired by the chef comunity postgresql cookbook : https://github.com/opscode-cookbooks/postgresql
#

action :create do

	pg_name = new_resource.name
	pg_root = new_resource.root_dir.chomp('/')
	pg_user = new_resource.user
	pg_group = new_resource.group
	pg_bin_dir = new_resource.pg_bin_dir.chomp('/')
	pg_data_dir = new_resource.custom_data_dir.chomp('/')

	log "Creating postgresql service #{pg_name}"

	# Ensure that we have the group and then the user
	group pg_group do
		system true
		action :create
		not_if "cat /etc/group | grep -q '#{pg_group}'"
	end

	user pg_user do
		shell "/bin/bash"
		comment "PgSQL user for service #{pg_name}"
		home pg_root
		gid pg_group
		system true
		supports :manage_home => false
		not_if "cat /etc/passwd | grep -q '#{pg_user}'"
	end

	# Render init script template
	template "/etc/init.d/#{pg_name}" do
		source "init-script.sh.erb"
		mode 0755
		variables(
			:pg_name => pg_name,
			:pg_user => pg_user,
			:pg_group => pg_group,
			:pg_pid_file => new_resource.custom_pid_file,
			:pg_version => new_resource.pg_version,
			:pg_prev_major_version => new_resource.pg_prev_major_version,
			:pg_bin_dir => pg_bin_dir,
			:pg_port => new_resource.port,
			:pg_data => pg_data_dir,
			:pg_log_file => new_resource.custom_log_file,
			:pg_root => pg_root,
			:pg_lock_file => new_resource.custom_lockfile_dir.chomp('/') + pg_name
		)
	end

	# Initialize DB cluster
	initdb_cmd = "#{pg_bin_dir}/initdb -D #{pg_data_dir} -U #{pg_user}"
	if new_resource.custom_pg_initdb_args and !new_resource.custom_pg_initdb_args.empty? then
		initdb_cmd += new_resource.custom_pg_initdb_args
	end
	log "Init db command : #{initdb_cmd}"
	execute "pg_initdb" do
		command initdb_cmd
		user pg_user
		cwd pg_root
		creates pg_data_dir + "/PG_VERSION"
	end

	# Configure our service
	postgresql_conf pg_name do
		action :apply
		service_dir pg_data_dir
		config node['postgresql']['server']['config']
		hba_config node['postgresql']['server']['pg_hba']
	end

	# Start our service and enable it at boot
	service pg_name do
	  supports :restart => true, :status => true, :reload => true
	  action [:enable,:start]
	end
end

action :delete do

	initScript = "/etc/init.d/#{new_resource.name}"

	service new_resource.name do
	  action [:disable,:stop]
	end

	file initScript do
		action :delete
		only_if "test -f #{initScript}"
	end

	file new_resource.custom_log_file do
		action :delete
		only_if "test -f #{new_resource.custom_log_file}"
	end

	directory new_resource.custom_data_dir do
		action :delete
		recursive true
		only_if "test -d #{new_resource.custom_data_dir}"
	end 
end

## These actions are just a wrapper to "service" chef resource
action :enable do
	service new_resource.name do
		action :enable
	end
end

action :disable do
	service new_resource.name do
		action :disable
	end
end

action :reload do
	service new_resource.name do
		action :reload
	end
end

action :restart do
	service new_resource.name do
		action :restart
	end
end

action :stop do
	service new_resource.name do
		action :stop
	end
end

action :start do
	service new_resource.name do
		action :start
	end
end
