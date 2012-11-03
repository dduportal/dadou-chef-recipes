#
# Cookbook Name:: dadou-chef-recipes
# Definition:: batchAddFiles
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#



define :batchAddFiles, :fileList => {} do
		
	params[:fileList].each do |filePath, options|
		# Creating containing dir if not existing
		# unless File.directory?(File.dirname(filePath))
		# 	directory File.dirname(filePath) do
		# 		owner 'root'
		# 		group 'root'
		# 		mode 0755
		# 		action :create
		# 		recursive true
		# 	end
		# end
		# File delivering go go !
		cookbook_file filePath do
	  		source options[:sourceFilePath]
			owner options[:owner]
			group options[:group]
			mode options[:mode]
	  	end
	end

end
