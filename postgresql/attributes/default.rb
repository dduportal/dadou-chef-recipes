#
# Cookbook Name:: postgresql
# Attributes:: default
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#

# PostgreSQL Attributes
default['postgresql'] = {
	'version' => {
		'major' => '9',
		'minor' => '2',
		'rpm' => '6'
	},
}
