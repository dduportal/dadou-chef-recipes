

include_recipe "build-essential"
include_recipe "apt"


packagesToInstall = ["git","vim","curl","aptitude","ruby","rubygems","sysstat"]

packagesToInstall.each do | pkg |
	package "#{pkg}" do
		action :install
	end
end
