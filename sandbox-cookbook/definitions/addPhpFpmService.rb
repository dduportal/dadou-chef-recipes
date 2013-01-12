#
# Cookbook Name:: dadou-chef-recipes
# Definition:: addPhpFpmService
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#

define :addPhpFpmService do

	clientId = params[:client_id]
	serviceId = params[:service_id]
	serviceUser = params[:service_user]
	serviceGroup = params[:service_group]

	rootFolder = "/srv/middle/#{clientId}/#{serviceId}"

	middleFolderList = {
		rootFolder => {
			:owner => serviceUser,
			:group => serviceUser,
			:mode => 0750
		},
		"#{rootFolder}/docs" => {
			:owner => serviceUser,
			:group => serviceGroup,
			:mode => 0750
		},
		"#{rootFolder}/conf" => {
			:owner => serviceUser,
			:group => serviceGroup,
			:mode => 0750
		},
		"#{rootFolder}/conf/conf.d" => {
			:owner => serviceUser,
			:group => serviceGroup,
			:mode => 0750
		},
		"#{rootFolder}/logs" => {
			:owner => serviceUser,
			:group => serviceUser,
			:mode => 0750
		},
		"#{rootFolder}/tmp" => {
			:owner => serviceUser,
			:group => serviceGroup,
			:mode => 0750
		}
	}

	phpTemplateList = {
		"#{rootFolder}/conf/php-fpm.conf" => {
			:templateFile => "php-fpm.conf.erb",
			:variables => {
	    		'service_root_folder' => rootFolder,
	  		},
	  		:owner => serviceUser,
	  		:group => serviceUser,
	  		:mode => 0750
		},
		"#{rootFolder}/conf/conf.d/#{serviceId}-pool.conf" => {
			:templateFile => "php-fpm-pool.conf.erb",
			:variables => {
	    		'service_root_folder' => rootFolder,
	    		'service_name' => "#{serviceId}",
	    		'service_listen_port' => '9000'
	  		},
	  		:owner => serviceUser,
	  		:group => serviceGroup,
	  		:mode => 0750
		},
		"/etc/init.d/php-fpm-#{serviceId}" => {
			:templateFile => "php-fpm-init-script.erb",
			:variables => {
	    		'service_root_folder' => rootFolder,
	  		},
	  		:owner => 'root',
	  		:group => 'root',
	  		:mode => 0755
		}
	}

	phpFileList = {
		"#{rootFolder}/conf/php.ini" => {
			:sourceFilePath => 'php.ini',
			:owner => serviceUser,
	  		:group => serviceGroup,
	  		:mode => 0750
		},
		"#{rootFolder}/docs/info.php" => {
			:sourceFilePath => 'info.php',
			:owner => serviceUser,
	  		:group => serviceGroup,
	  		:mode => 0750
		}
	}

	## Reusable function  for flushin yum internal cache
	ruby_block "reload-internal-yum-cache" do
	  block do
	    Chef::Provider::Package::Yum::YumCache.instance.reload
	  end
	  action :nothing
	end
	cookbook_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-remi" do
		source 'RPM-GPG-KEY-remi'
		mode 0644
    	notifies :create, resources(:ruby_block => "reload-internal-yum-cache"), :immediately
	end
	cookbook_file "/etc/yum.repos.d/remi.repo" do
		source 'remi.repo'
		mode 0644
	end
	["php-fpm","php","php-gd","php-curl"].each do |pkgToInstall|
		package pkgToInstall do
			action :install
		end
	end
	batchCreateFolders "create_phpfpm_service_dirs" do
		foldersList middleFolderList
	end

	batchAddFiles "Add_phpfpm_files" do
		fileList phpFileList
	end

	batchProcessTemplates "Create_phpfpm_template_files" do
		templateList phpTemplateList
	end

	script "configure_service" do
	  interpreter "bash"
	  user "root"
	  code <<-EOH
	  chkconfig php-fpm off
	  chkconfig php-fpm-#{serviceId} on
	  EOH
	end
end