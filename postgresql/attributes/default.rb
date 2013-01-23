#
# Cookbook Name:: postgresql
# Attributes:: default
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#

# PostgreSQL Attributes
default['postgresql']['version'] = {
	'major' => '8',
	'minor' => '4',
	'repo_rpm' => 'http://yum.postgresql.org/8.4/redhat/rhel-6-x86_64/pgdg-centos-8.4-3.noarch.rpm'
}
