#
# Cookbook Name:: dadou-chef-recipes
# Recipe:: main
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#

## Add my supplementals repos (EPEL, etc.)
node[:dadou][:yum][:custom_repo].each do |customrepo|
  cookbook_file "/etc/yum.repos.d/" + customrepo do
    source customrepo
    mode "0644"
  end
end

# Install all needed base packages
node[:dadou][:yum][:packages].each do |pkgToInstall|
  package pkgToInstall do
    action :install
  end
end

# Yum global update
execute "Yum_update" do
  command "sudo yum -y update"
  action :run
end

# Create front service
addNginxService "Create_nginx_front_service" do
  client_id "dadou"
  service_id "local"
  service_user "vagrant"
  service_group "vagrant"
  # upstreamList { 'mytomcat' => ['127.0.0.1:8080'] }
end
