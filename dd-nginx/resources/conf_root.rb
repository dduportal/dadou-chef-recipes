#
# Cookbook Name:: nginx
# Resource:: conf_root
#
# Copyright 2013, Damien DUPORTAL
#
#

actions :configure

default_action :configure

attribute :nginx_conf_file, :kind_of => String, :name_attribute => true
attribute :nginx_conf, :kind_of => [Hash, NilClass], :default => {}
attribute :cookbook, :kind_of => String, :default => 'dd-nginx' # Use this to overwrite cookbook's templates provider
