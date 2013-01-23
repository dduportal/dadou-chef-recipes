#
# Cookbook Name:: postgresql
# Resource:: conf
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#
# This resource is a postgresql-server service configuration
# postgresql.conf and pg_hba.conf
#

actions :apply
default_action :apply

attribute :service_name, :kind_of => String, :name_attribute => true
attribute :service_dir, :kind_of => String, :default => "/var/lib/pgsql/9.2/data"
attribute :config, :kind_of => Hash, :default => {}
attribute :hba_config, :kind_of => Array, :default => []