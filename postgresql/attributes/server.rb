
default['postgresql']['server']['config'] = {
	'listen_addresses' => '*',
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
}

default['postgresql']['server']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'trust'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '10.0.2.2/16', :method => 'trust' },
  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'trust'},
]