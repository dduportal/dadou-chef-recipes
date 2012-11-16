#
#

nginx_service "www.dadou.net" do
	client_id "dadou"
	service_user "vagrant"
	service_group "vagrant"
	action :create
end