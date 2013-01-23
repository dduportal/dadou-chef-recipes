# Dadou PostgreSQL recipe

This recipe aims to install and configure and official postgresql server

# Platform Support

Recipe tested with :
 * Centos 6.3 - i386 
 * Centos 6.3 - x64

# Attributes

We have these files representing atomic default attributes :

## default.rb

Attributes are set from a big JSON hash with these typology :
````ruby
default['postgresql']['version']
`````
Containing versions and yum repo source as it :
* 'major' : Major version of PostgreSQL. Default is '8'
* 'minor' : Minor version of PostgreSQL. Default is '4'
* 'repo_rpm' : URL of the yum repo rpm, extracted from officials postgresql yum repos from http://yum.postgresql.org/repopackages.php. Default to http://yum.postgresql.org/8.4/redhat/rhel-6-x86_64/pgdg-centos-8.4-3.noarch.rpm

## server.rb

 ````ruby
 default['postgresql']['server']['config']
 ````
 Hash of postgresql.conf directives. See attributes/server.rb for default attributes.
 
 ````ruby
 default['postgresql']['server']['pg_hba']
 ````
 Array of pg_hba entries. See attributes/server.rb for default attributes.

## postgis.rb

````ruby
default['postgresql']['postgis']['version']
`````
Actually, this is the "short postgis rpm version". Default : 2 (example : postgresql92-postgis2, postgresql91-postgis15 ...)

# Recipes

  * default : This recipe will just ensure you have the officials postgresql repositories into your redhat-yum compliant distribution
  * client : This recipe wil install default postgresql client tools, calling default recipe in order to know version.
  * server : This recipe wil install a standard postgresql server, calling default recipe in order to know version. A default fully functionnal service is created and launched with this recipes, based onto LWRP service and conf. This service is named "postgresql-<VERSION>".
  * postgis : This recipe will install postgis (and all needed depenendies) over your current postgresql installation, based onto default recipe call for version.

# LRWP

We implements to LightWeight Resources Providers in order to ease postgresql services use :
  
## postgresql_service

this LRWP will manage a postgresql service

### Parameters
(See providers/service.rb to see all default valuers/declarations) :

````ruby
# Some example call
pgsql_version = "9.2"
postgresql_service "my_pg_server" do
	action :create
	root_dir "/srv/pgsql/" # Root dir of service, containing pgstartup.log, home of service's owner
	pg_data_dir "/srv/pgsql/my_pg_server" # If not in #{root_dir}/data
	user "postgres" # Owner of service
	group "postgres" # Group owner of service
	pg_bin_dir "/usr/pgsql-#{pgsql_version}/bin" # where are your psql, etc. binaries ?
	custom_port 5432 # Port where service is listening
	custom_log_file "/var/lib/pgsql/#{pgsql_version}/pgstartup.log" # pgstartup.log if not in #{root_dir}
	custom_pid_file "/var/run/postmaster-#{pgsql_version}.pid"
	custom_lockfile_dir "/var/lock/subsys"
	pg_version "#{pgsql_version}"
end
````
### Actions :
  * :create : will create the service, configure it from node's attributes, enable it and launch it.
  * :delete : Stop, disable, and erase service. Will delete all log/lock/pid/data files/dir.
  * :start : launch the service
  * :stop : shut down properly the service
  * :reload : reload on-the-fly postgresql and it's configuration, without throwing away connections.
  * :restart : completeley restart the service.
  * :enable : add the service to the boot launch items.
  * :disable : remove the service from the boot launch items.

## postgresql_conf

this LRWP will configure a postgresql service from node's attributes

### Parameters
(See providers/conf.rb to see all default valuers/declarations) :

````ruby
# Some example call
pgsql_conf = "9.2"
postgresql_conf "my_pg_server" do
	service_dir "/var/lib/pgsql/9.2/data" # Where is your service data dir ?
	config { 'Some' => 'Hash'} # Key/Value hash containing postgresql directives
	hba_config [Array,Of,hba] # Array containing all entries (hash) for pg_hba.
end
````
### Actions :
  * :apply : Unique and default action. Apply conf and reload (or restart) the service
