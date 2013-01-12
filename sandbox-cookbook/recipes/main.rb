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
# Be carefull with vbox additions and updating kernel, use https://github.com/dotless-de/vagrant-vbguest
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
end

# Create middle service
addPhpFpmService "Create_phpfpm_middle_service" do
  client_id "dadou"
  service_id "local"
  service_user "vagrant"
  service_group "vagrant"
end

# Add php location to the nginx front service
execute "configure_service" do
  user "vagrant"
  command "sed -i 's/^}$/    include phplocation.conf;\\n}/g' /srv/front/dadou/local/conf/vhosts/local.conf"
end
template "/srv/front/dadou/local/conf/phplocation.conf" do
  source "phplocation.conf.erb"
  owner "vagrant"
  group "vagrant"
  mode 0750
  variables({
    "service_root" => "/srv/middle/dadou/local",
    "service_listen_port" => 9000
  })
end
cookbook_file "/srv/front/dadou/local/conf/fastcgi_params" do
  source "fastcgi_params"
end
