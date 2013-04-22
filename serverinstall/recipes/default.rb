

include_recipe "build-essential"
include_recipe "apt"

## Install our packages

packagesToInstall = ["git","vim","curl","aptitude","ruby","rubygems","sysstat"]

packagesToInstall.each do | pkg |
	package "#{pkg}" do
		action :install
	end
end

## Activate sysstats
execute "activate-systat" do
	command "sed 's/ENABLED="false"/ENABLED="true"/g' /etc/default/sysstat"
end

