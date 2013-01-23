# Dadou PostgreSQL recipe

This recipe aims to install and configure and official postgresql server

# Platform Support

Recipe tested with :
 * Centos 6.3 - i386 
 * Centos 6.3 - x64

# Attributes

We have these files represnting atomic default attributes :

## default.rb

Attributes are set from a big JSON hash with these typology :
 * node['postgresql']['version'] : Containing versions and yum repo source
  > 'major' : default is '8'
  > 'minor' : default is '4'
  > 'repo_rpm' : Extracted from officials postgresql yum repos from http://yum.postgresql.org/repopackages.php. Default to http://yum.postgresql.org/8.4/redhat/rhel-6-x86_64/pgdg-centos-8.4-3.noarch.rpm
 * node['postgresql']['server']['config'] : hash of postgresql.conf directives. See attributes/default.rb for default attributes.
 * node['postgresql']['server']['pg_hba'] : Array of pg_hba entries. See attributes/default.rb for default attributes.

## postgis.rb

Attribute for the postgis recipe :
 * node['postgresql']['postgis']['version'] : Actually, this is the "short postgis rpm version". Default : 2 (example : postgresql92-postgis2, postgresql91-postgis15 ...)

# Recipes

  * default : This recipe will just ensure you have the officials postgresql repositories into your redhat-yum compliant distribution
  * client : This recipe wil install default postgresql client tools, calling default recipe in order to know version.
  * server : This recipe wil install a standard postgresql server, calling default recipe in order to know version. A default fully functionnal service is created and launched with this recipes, based onto LWRP service and conf. This service is named "postgresql-<VERSION>".
  * postgis : This recipe will install postgis (and all needed depenendies) over your current postgresql installation, based onto default recipe call for version.

# LRWP

We implements to LightWeight Resources Providers in order to ease postgresql services use :
  
  * service : this LRWP will create a postgresql service, enable it by default and launch it.
   > Parameters (See providers/service.rb to see all default valuers/declarations) :
````ruby
# Some example call
postgresql_service "my_pg_server" do
	action :create
	root_dir "/srv/pgsql/"
	custom_data_dir "/srv/pgsql/my_pg_server"
	pg_bin_dir "/usr/pgsql-#{pgsql_version}/bin"
	custom_log_file "/var/lib/pgsql/#{pgsql_version}/pgstartup.log"
	custom_pid_file "/var/run/postmaster-#{pgsql_version}.pid"
	custom_lockfile_dir "/var/lock/subsys"
	pg_version "#{pgsql_version}"
end
````