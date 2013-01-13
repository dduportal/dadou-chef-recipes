#
# Cookbook Name:: postgresql
# Attributes:: default
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#

# PostgreSQL Attributes
node.set['postgresql'] = {
	'version' => {
		'major' => '9',
		'minor' => '2',
		'rpm' => '6'
	},
	'server' => {
		'config' => {
			'listen_addresses' => 'localhost',
			'max_connections' => 100,
			'shared_buffers' => '32MB',
			'log_destination' => 'stderr',
			'logging_collector' => true,
			'log_directory' => 'pg_log',
			'log_filename' => 'postgresql-%a.log',
			'log_truncate_on_rotation' => true,
			'log_rotation_age' => '1d',
			'log_rotation_size' => 0,
			'log_timezone' => 'US/Eastern',
			'datestyle' => 'iso, mdy',
			'lc_messages' => 'C',
			'lc_monetary' => 'C',
			'lc_numeric' => 'C',
			'lc_time' => 'C',
			'default_text_search_config' => 'pg_catalog.english',
		},
		'pg_hba' => [
		  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
		  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
		  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
		  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'},
		  {:type => 'host', :db => 'all', :user => 'all', :addr => '10.0.2.2/16', :method => 'md5' }
		]
	}
}
