#
# Cookbook Name:: nginx
# Resource:: conf_vhost
#
# Copyright 2013, Damien DUPORTAL
#
#

actions :add, :remove, :update

attribute :vhost_name, :kind_of => String, :name_attribute => true
attribute :nginx_service, :kind_of => String, :required => true
attribute :nginx_vhosts_dir, :kind_of => String, :required => true
attribute :nginx_user, :kind_of => String, :regex => Chef::Config[:user_valid_regex], :default => "www"
attribute :nginx_group, :kind_of => String, :regex => Chef::Config[:group_valid_regex]
attribute :vhost_conf, :kind_of => [Hash, NilClass], :default => {}
attribute :cookbook, :kind_of => String, :default => 'dd-nginx' # Use this to overwrite cookbook's templates provider
