#
# Cookbook Name:: postgresql
# Attributes:: postgis
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#

# PostGIS Attributes
default['postgresql'] = {
	'postgis' => {
		'version' => "2"
	}
}
