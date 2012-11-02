#
# Cookbook Name:: dadou-chef-recipes
# Definition:: addGenericFrontService
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#


define :addGenericFrontService do
	
	clientId = params[:client_id]
	serviceId = params[:service_id]
	serviceUser = params[:service_user]
	serviceGroup = params[:service_group]
	rootFolder = params[:root_folder]

	frontFolderList = {
		rootFolder => {
			:owner => serviceUser,
			:group => serviceUser,
			:mode => 0755
		},
		"#{rootFolder}/docs" => {
			:owner => serviceUser,
			:group => serviceGroup,
			:mode => 0755
		},
		"#{rootFolder}/conf/vhosts" => {
			:owner => serviceUser,
			:group => serviceUser,
			:mode => 0755
		},
		"#{rootFolder}/conf/locations" => {
			:owner => serviceUser,
			:group => serviceUser,
			:mode => 0755
		},
		"#{rootFolder}/logs" => {
			:owner => serviceUser,
			:group => serviceUser,
			:mode => 0755
		},
	}

	batchCreateFolders "createFrontService" do
		foldersList frontFolderList
	end

end
