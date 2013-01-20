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
attribute :pg_bin_dir, :kind_of => String
attribute :port, :kind_of => Integer, :default => 5432
attribute :custom_data_dir, :kind_of => String
attribute :custom_log_file, :kind_of => String
attribute :custom_pid_file, :kind_of => String
attribute :custom_lockfile_dir, :kind_of => String
attribute :pg_version, :kind_of => String
attribute :custom_pg_initdb_args, :kind_of => String, :default => ""
