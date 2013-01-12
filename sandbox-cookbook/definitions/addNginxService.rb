#
# Cookbook Name:: dadou-chef-recipes
# Definition:: addNginxService
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#


define :addNginxService do

	clientId = params[:client_id]
	serviceId = params[:service_id]
	serviceUser = params[:service_user]
	serviceGroup = params[:service_group]

	rootFolder = "/srv/front/#{clientId}/#{serviceId}"

	frontFolderList = {
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
		"#{rootFolder}/conf/vhosts" => {
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

	nginxTemplateList = {
		"#{rootFolder}/conf/nginx.conf" => {
			:templateFile => "nginx.conf.erb",
			:variables => {
	    		'nginx_user' => serviceUser,
	    		'nginx_group' => serviceGroup,
	    		'service_root_folder' => rootFolder,
	  		},
	  		:owner => serviceUser,
	  		:group => serviceUser,
	  		:mode => 0750
		},
		"#{rootFolder}/docs/index.html" => {
			:templateFile => "index.html.erb",
			:variables => {
	    		'service' => serviceId,
	  		},
	  		:owner => serviceUser,
	  		:group => serviceGroup,
	  		:mode => 0750
		},
		"#{rootFolder}/conf/vhosts/#{serviceId}.conf" => {
			:templateFile => "nginx-vhost.conf.erb",
			:variables => {
	    		'service_root_folder' => rootFolder,
	    		'docroot' => "#{rootFolder}/docs",
	    		'listen_port' => '80'
	  		},
	  		:owner => serviceUser,
	  		:group => serviceGroup,
	  		:mode => 0750
		},
		"/etc/init.d/nginx-#{serviceId}" => {
			:templateFile => "nginx-init-script.erb",
			:variables => {
	    		'service_root_folder' => rootFolder,
	    		'service_name' => serviceId,
	    		'service_description' => "My custom Nginx front"
	  		},
	  		:owner => 'root',
	  		:group => 'root',
	  		:mode => 0755
		}
	}

	nginxFileList = {
		"#{rootFolder}/conf/mime.types" => {
			:sourceFilePath => 'mime.types',
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
	cookbook_file "/etc/yum.repos.d/nginx.repo" do
		source 'nginx.repo'
		mode 0644
    	notifies :create, resources(:ruby_block => "reload-internal-yum-cache"), :immediately
	end
	package "nginx" do
		action :install
		version '1.2.4-1.el6.ngx'
	end

	## Laucnh creation of service
	batchCreateFolders "create_nginx_service_dirs" do
		foldersList frontFolderList
	end

	batchAddFiles "Add_nginx_files" do
		fileList nginxFileList
	end

	batchProcessTemplates "Create_nginx_template_files" do
		templateList nginxTemplateList
	end

	script "configure_service" do
	  interpreter "bash"
	  user "root"
	  code <<-EOH
	  chkconfig nginx off
	  chkconfig nginx-#{serviceId} on
	  EOH
	end

	
end