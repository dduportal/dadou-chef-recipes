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


pg_log_file = nil
pg_lock_file = nil
pg_pid_file = nil
pg_data_dir = nil
pg_root = nil

action :create do

	pg_name = new_resource.name
	pg_user = new_resource.user
	pg_group = new_resource.group
	pg_bin_dir = new_resource.pg_bin_dir.chomp('/')
	pg_version = new_resource.pg_version
	if new_resource.root_dir then
		pg_root = new_resource.root_dir.chomp('/')
	else
		pg_root = "/var/lib/pgsql/#{pg_version}"
	end
	if new_resource.pg_data_dir then
		pg_data_dir = new_resource.pg_data_dir
	else
		pg_data_dir = "#{pg_root}/data"
	end
	if new_resource.custom_log_file then
		pg_log_file = new_resource.custom_log_file
	else
		pg_log_file =  "#{pg_root}/logs/pgstartup.log"
	end
	if new_resource.custom_pid_file then
		pg_pid_file = new_resource.custom_pid_file
	else
		pg_pid_file =  "#{pg_root}/tmp/postmaster-#{pg_name}.pid"
	end
	if new_resource.custom_lockfile then
		pg_lock_file = new_resource.custom_lockfile
	else
		pg_lock_file =  "#{pg_root}/tmp/#{pg_name}.lock"
	end
	pgsql_major_version = pg_version.split('.')[0]
	pgsql_minor_version = pg_version.split('.')[1]

	if pgsql_minor_version == 0 then
		pg_prev_major_version = ((pgsql_major_version.to_i) - 1).to_s + ".0"
	else
		pg_prev_major_version = pgsql_major_version + "." + ((pgsql_minor_version.to_i) - 1).to_s
	end

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

	# Ensure all needed folder are here and OK
	directory pg_root do
		action :create
		recursive true
		not_if "test -d #{pg_root}"
	end

	directory pg_data_dir do
		action :create
		recursive true
		not_if "test -d #{pg_data_dir}"
	end

	pg_log_dir = IO::File.dirname(pg_log_file) 
	directory pg_log_dir do
		action :create
		recursive true
		not_if "test -d #{pg_log_dir}"
	end

	directory IO::File.dirname(pg_pid_file) do
		action :create
		recursive true
		not_if "test -d $(dirname #{pg_pid_file})"
	end

	directory IO::File.dirname(pg_lock_file) do
		action :create
		recursive true
		not_if "test -d $(dirname #{pg_lock_file})"
	end

	# Render init script template
	template "/etc/init.d/#{pg_name}" do
		source "init-script.sh.erb"
		mode 0755
		variables(
			:pg_name => pg_name,
			:pg_user => pg_user,
			:pg_group => pg_group,
			:pg_pid_file => pg_pid_file,
			:pg_version => pg_version,
			:pg_prev_major_version => pg_prev_major_version,
			:pg_bin_dir => pg_bin_dir,
			:pg_port => new_resource.custom_port,
			:pg_data => pg_data_dir,
			:pg_log_file => pg_log_file,
			:pg_root => pg_root,
			:pg_lock_file => pg_lock_file
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

	file pg_log_file do
		action :delete
		only_if "test -f #{pg_log_file}"
	end

	file pg_lock_file do
		action :delete
		only_if "test -f #{pg_lock_file}"
	end

	file pg_pid_file do
		action :delete
		only_if "test -f #{pg_pid_file}"
	end

	directory pg_data_dir do
		action :delete
		recursive true
		only_if "test -d #{pg_data_dir}"
	end

	directory pg_root do
		action :delete
		recursive true
		only_if "test -d #{pg_root}"
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
