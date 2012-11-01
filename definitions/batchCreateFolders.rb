#
# Cookbook Name:: dadou-chef-recipes
# Definition:: batchCreateFolders
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#

define :batchCreateFolders, :foldersList => {} do
		
	params[:foldersList].each do |folder, options|
		directory folder do
			owner options[:owner]
			group options[:group]
			mode options[:mode]
			action :create
			recursive true
		end
	end

end
