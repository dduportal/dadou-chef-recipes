#
# Cookbook Name:: dadou-chef-recipes
# Attributes:: postgresql
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#


# PostgreSQL Attributes
default['dadou']['postgresql'] = {
	'version' => {
		'major' => '9',
		'minor' => '2'
	},
	'dir' => "/var/lib/pgsql/data",
	'password' => {
		"postgres" => 'passwordpassword'
	}
}
