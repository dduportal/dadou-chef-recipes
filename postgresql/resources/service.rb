#
# Cookbook Name:: postgresql
# Resource:: service
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#
# This resource is a postgresql-server service instance
#

actions :create, :delete, :start, :stop, :reload, :restart, :enable, :disable

attribute :name, :kind_of => String, :name_attribute => true
attribute :root_dir, :kind_of => String, :default => "/var/lib/pgsql"
attribute :user, :kind_of => String, :default => "postgres"
attribute :group, :kind_of => String, :default => "postgres"
attribute :pg_bin_dir, :kind_of => String, :default => "/usr/pgsql-9.2/bin"
attribute :port, :kind_of => Integer, :default => 5432
attribute :custom_data_dir, :kind_of => String, :default => "/var/lib/pgsql/9.2/data"
attribute :custom_log_file, :kind_of => String, :default => "/var/lib/pgsql/9.2/pgstartup.log"
attribute :custom_pid_file, :kind_of => String, :default => "/var/run/postmaster-9.2.pid"
attribute :custom_lockfile_dir, :kind_of => String, :default => "/var/lock/subsys"
attribute :pg_version, :kind_of => String, :default => "9.2.2"
attribute :pg_prev_major_version, :kind_of => String, :default => "9.1"
attribute :custom_pg_initdb_args, :kind_of => String, :default => ""
