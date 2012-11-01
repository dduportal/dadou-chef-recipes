#
# Cookbook Name:: dadou-chef-recipes
# Definition:: addNginxService
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#


define :addNginxService,:upstreamList => {} do

	clientId = params[:client_id]
	serviceId = params[:service_id]
	serviceUser = params[:service_user]
	serviceGroup = params[:service_group]
	upstreamList = params[:upstreamList]

	rootFolder = "/srv/webs/#{clientId}/#{serviceId}"

	## First we have to create generic struct.
	addGenericFrontService "Create_generic_front_service" do
		client_id clientId
		service_id serviceId
		service_user serviceUser
		service_group serviceGroup
	end


	## Then we have to call batchTemplateCreate in order to create Nginx service
	nginxTemplateList = {
		"#{rootFolder}/conf/nginx.conf" => {
			:templateFile => "nginx.conf.erb",
			:variables => {
	    		'nginx_user' => serviceUser,
	    		'nginx_group' => serviceGroup,
	    		'has_upstreams' => false,
	    		'service_root_folder' => rootFolder,
	  		},
	  		:owner => serviceUser,
	  		:group => serviceUser,
	  		:mode => 0644
		},
		"#{rootFolder}/conf/upstream.conf" => {
			:templateFile => "upstream.conf.erb",
			:variables => {
	    		'upstream_list' => upstreamList
	  		},
	  		:owner => serviceUser,
	  		:group => serviceGroup,
	  		:mode => 0644
		},
		"#{rootFolder}/docs/index.html" => {
			:templateFile => "index.html.erb",
			:variables => {
	    		'service' => serviceId,
	  		},
	  		:owner => serviceUser,
	  		:group => serviceGroup,
	  		:mode => 0644
		},
		"#{rootFolder}/conf/vhosts/#{serviceId}.conf" => {
			:templateFile => "servername.conf.erb",
			:variables => {
	    		'server_name' => serviceId,
	    		'server_aliases' => "localhost #{node[:fqdn]}",
	    		'service_root_folder' => rootFolder,
	    		'ip' => '127.0.0.1',
	    		'docroot' => "#{rootFolder}/docs",
	    		'upstreams' => {},
	    		# 	'mytomcat' => '/'
	    		# }

	  		},
	  		:owner => serviceUser,
	  		:group => serviceGroup,
	  		:mode => 0644
		},
	}


	batchCreateTemplates "Create_nginx_template_files" do
		templateList nginxTemplateList
	end
	
end