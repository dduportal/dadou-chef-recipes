#
# This the default attributes file for nginx recipe
# You can override this in your rown recipes
#

#default['nginx']['packagename'] = 'nginx'
node.default['nginx']['version'] = '1.0.5'

default['nginx']['root_conf']['user'] = ['vagrant','vagrant']
default['nginx']['root_conf']['worker_processes'] = 1
default['nginx']['root_conf']['error_log'] = ['logs/error.log','warn']
default['nginx']['root_conf']['other_core_directives'] = {
	'pid' => 'logs/nginx.pid',
}
default['nginx']['root_conf']['events_directives'] = {
	'worker_connections' => 1024,
}
default['nginx']['root_conf']['http']['log_format'] = [
	'main',
	'\'$remote_addr - $remote_user [$time_local] "$request" \'', "\n\t\t",
	'\'$status $body_bytes_sent "$http_referer" \'', "\n\t\t",
	'\'"$http_user_agent" "$http_x_forwarded_for"\''
]
default['nginx']['root_conf']['http']['access_log'] = ['logs/access.log','main']

default['nginx']['root_conf']['http']['other_directives'] = {
	'default_type' => 'application/octet-stream',
	'sendfile' => 'on',
	'keepalive_timeout' => 65,
}
