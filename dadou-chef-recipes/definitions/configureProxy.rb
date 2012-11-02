#
# Cookbook Name:: dadou-chef-recipes
# Definition:: configureProxy
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#


define :configureProxy, :enable => false do
	
	isProxyEnabled = params[:enable]
	proxyUrl = params[:proxyUrl]
	proxyPort = params[:proxyPort]

	proxyEnVars = ['http_proxy','https_proxy']
	pkgManagerConfFile = '/etc/yum.conf'
	mainProfileFile = '/etc/profile'

	# Write all HTTP PROXY env vars into /etc/profile
	proxyEnVars.each do |envVar|
	  script "clean_proxy" do
	    interpreter "bash"
	    user "root"
	    code <<-EOH
	    sed -i '/^export #{envVar}=.*$/d' #{mainProfileFile}
	    EOH
	  end
	  if isProxyEnabled
	  	script "add_proxy" do
		    interpreter "bash"
		    user "root"
		    code <<-EOH
		    echo export #{envVar}=#{proxyUrl}:#{proxyPort} >> #{mainProfileFile}
		    EOH
		  end
	  end
	end

	# Configuring yum to use only dadou proxy
	script "add_proxy_to_yum" do
	  interpreter "bash"
	  user "root"
	  code <<-EOH
	  sed -i '/^proxy=.*$/d' #{pkgManagerConfFile}
	  EOH
	end
	if isProxyEnabled
	  script "add_proxy" do
	    interpreter "bash"
	    user "root"
	    code <<-EOH
	  	echo proxy=#{proxyUrl}:#{proxyPort} >> #{pkgManagerConfFile}
	    EOH
	  end
	end
end
