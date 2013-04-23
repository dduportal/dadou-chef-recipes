#
# Cookbook Name:: vagrant
# Recipe:: default
#
# Copyright 2013, Damien DUPORTAL
#
#

# Not for Mac OS nor Windows 
if node['platform'] != "windows" and node['platform'] != "macos" then
	
	# We have to donwload the installer package
	fileName = get_package_name(node['vagrant']['version'])

	remote_file "/tmp/#{fileName}" do
		source "#{node['vagrant']['versionUrl']}/#{fileName}"
	end

	# Then, installing and go
	case node['platform']
	when "ubuntu", "debian"
		dpkg_package "#{fileName}" do
			source "/tmp/#{fileName}"
			action :install
		end
	else
		log "Don't know how to install #{fileName} on this platform : #{node['platform']}"
	end

else
	log "Node platform #{node['platform']} not supported ! Nothing to do."
end


def get_package_name(version)
	genericFileName = "vagrant_#{node['vagrant']['version']}_#{node['arch']}"

	# Preparing download name
	case node['platform']
	when "ubuntu", "debian"
		return "#{genericFileName}.deb"
	when "centos","rhel","lfs","fedora","enterprise"
		return "#{genericFileName}.rpm"
	when "arch"
		return "#{genericFileName}.pkg.tar.xz"
	else
		return nil
	end
end
