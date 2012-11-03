#
# Cookbook Name:: dadou-chef-recipes
# Definition:: batchProcessTemplates
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#



define :batchProcessTemplates, :templateList => {} do
		
	params[:templateList].each do |templatePath, options|
		# Creating containing dir if not existing
		# unless File.directory?(File.dirname(templatePath))
		# 	directory File.dirname(templatePath) do
		# 		owner 'root'
		# 		group 'root'
		# 		mode 0755
		# 		action :create
		# 		recursive true
		# 	end
		# end
		# Templating go go !
		template templatePath do
	  		source options[:templateFile]
			owner options[:owner]
			group options[:group]
			mode options[:mode]
	  		variables(options[:variables])
	  	end
	end

end
